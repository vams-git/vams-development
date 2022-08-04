DECLARE
  mtp     r5maintenancepatterns%ROWTYPE;
  cpeq    NUMBER;
  voborg  r5patternequipment.peq_object_org%TYPE;
  vob     r5patternequipment.peq_object%TYPE;
  chkpeq  NUMBER;
  peq     r5patternequipment%ROWTYPE;
  crevt   NUMBER;
  vmetdue r5events.evt_meterdue%TYPE;
  voutwo  r5events.evt_code%TYPE;
  chk     VARCHAR2(3);
  caevt   NUMBER;
  ipeq    NUMBER;
  err     EXCEPTION;
  imsg    VARCHAR2(400);
  --cursor for released work order
  CURSOR cur_revt(vmporg VARCHAR2, vmp VARCHAR2,
    vmprev NUMBER, vmpoborg VARCHAR2, vmpob VARCHAR2) IS
    SELECT evt_code FROM  r5events
    WHERE evt_rstatus != 'A' AND evt_mp_org = vmporg
      AND evt_mp = vmp AND evt_mp_rev = vmprev
      AND evt_object_org = vmpoborg AND evt_object = vmpob
      AND NVL(evt_reopened,'-') = '-';
  --cursor for unrelease work order
  CURSOR cur_aevt(vmporg VARCHAR2, vmp VARCHAR2,
    vmprev NUMBER, vmpoborg VARCHAR2, vmpob VARCHAR2) IS
    SELECT evt_code FROM r5events
    WHERE evt_rstatus = 'A' AND evt_mp_org = vmporg
      AND evt_mp = vmp AND evt_mp_rev = vmprev
      AND evt_object_org = vmpoborg AND evt_object = vmpob;

BEGIN
  SELECT * INTO mtp FROM r5maintenancepatterns
  WHERE ROWID = :rowid;

  IF mtp.mtp_udfchar02 = 'RSET' THEN
    --count MP equipment
    SELECT Count(1) INTO cpeq FROM r5patternequipment
    WHERE peq_mp_org = mtp.mtp_org
      AND peq_mp = mtp.mtp_code
      AND peq_revision = mtp.mtp_revision;

    IF cpeq = 0 THEN
      --refresh MP fields
      IF NVL(mtp.mtp_udfchkbox04,'-') != '+' THEN
        UPDATE r5maintenancepatterns 
        SET mtp_udfchar02 = NULL,
            mtp_udfchar04 = NULL,
            mtp_udfchar05 = NULL,
            mtp_udfchkbox04 = '+'
        WHERE mtp_org = mtp.mtp_org
          AND mtp_code = mtp.mtp_code
          AND mtp_revision = mtp.mtp_revision;
        RETURN;
      END IF;
      IF NVL(mtp.mtp_udfchkbox04,'-') = '+' THEN
        imsg := 'No equipment setup for this MP';
        RAISE err;
      END IF;
    END IF;

    IF cpeq > 1 AND mtp.mtp_udfchar04 IS NULL 
      AND mtp.mtp_udfchar05 IS NULL THEN
      imsg := 'There are more than (1) equipment setup for this MP';
      RAISE err;
    END IF;

    --initialise target MP equipment
    IF mtp.mtp_udfchar04 IS NOT NULL
      AND mtp.mtp_udfchar05 IS NOT NULL THEN
      vob := mtp.mtp_udfchar04;
      voborg := mtp.mtp_udfchar05;
      --check MP equipment exist
      SELECT Count(1) INTO chkpeq FROM r5patternequipment
      WHERE peq_mp_org = mtp.mtp_org
        AND peq_mp = mtp.mtp_code
        AND peq_revision = mtp.mtp_revision
        AND peq_object_org = voborg
        AND peq_object = vob;
      IF chkpeq = 0 THEN
        imsg := 'Equipment selected not exist on this MP';
        RAISE err;
      END IF;
    END IF;

    IF mtp.mtp_udfchar04 IS NULL
      OR mtp.mtp_udfchar05 IS NULL THEN
      SELECT * INTO peq FROM r5patternequipment
      WHERE peq_mp_org = mtp.mtp_org
        AND peq_mp = mtp.mtp_code
        AND peq_revision = mtp.mtp_revision;
      vob := peq.peq_object;
      voborg := peq.peq_object_org;
    END IF;

    --system close all release workorder
    SELECT Count(1) INTO crevt FROM r5events
      WHERE evt_rstatus != 'A' AND evt_mp_org = mtp.mtp_org
      AND evt_mp = mtp.mtp_code AND evt_mp_rev = mtp.mtp_revision
      AND evt_object_org = voborg AND evt_object = vob
      AND NVL(evt_reopened, '-') = '-';
      
    IF crevt > 0 THEN
      FOR rec_rwo IN cur_revt(mtp.mtp_org, mtp.mtp_code,
        mtp.mtp_revision, voborg, vob) LOOP

        O7crevt8 (rec_rwo.evt_code, mtp.mtp_code,
          mtp.mtp_org, mtp.mtp_revision, vob, voborg,
          NULL, vmetdue, NULL, 0, NULL, voutwo, chk);
        
        DELETE FROM r5events WHERE evt_code = voutwo;
        
        UPDATE r5events SET evt_reopened = '+'
        WHERE evt_code = rec_rwo.evt_code
          AND NVL(evt_reopened, '-') = '-';
      END LOOP;
    END IF;
    
    --remove all awaiting workorder
    SELECT Count(1) INTO caevt FROM r5events
    WHERE evt_rstatus = 'A' AND evt_mp_org = mtp.mtp_org
      AND evt_mp = mtp.mtp_code AND evt_mp_rev = mtp.mtp_revision
      AND evt_object_org = voborg AND evt_object = vob;
      
    IF caevt > 0 THEN
      FOR rec_awo IN cur_aevt(mtp.mtp_org, mtp.mtp_code,
        mtp.mtp_revision, voborg, vob) LOOP
        DELETE FROM r5events WHERE evt_code = rec_awo.evt_code;
      END LOOP;
    END IF;

    --update MP Equipment status to inactive
    UPDATE r5patternequipment SET peq_status = 'I'
    WHERE peq_status != 'A'
      AND peq_mp_org = mtp.mtp_org AND peq_mp = mtp.mtp_code
      AND peq_revision = mtp.mtp_revision
      AND peq_object_org = voborg AND peq_object = vob;
    
    --remove any unassigned awaiting workorder
    DELETE FROM r5events WHERE evt_rstatus = 'A'
      AND evt_ppm IS NULL AND evt_mp IS NULL;

    --count inactive MP equipment
    SELECT Count(1) INTO ipeq FROM r5patternequipment
    WHERE peq_mp_org = mtp.mtp_org AND peq_mp = mtp.mtp_code
      AND peq_revision = mtp.mtp_revision
      AND peq_status = 'I';

    --refresh MP fields
    IF cpeq = ipeq THEN
      UPDATE r5maintenancepatterns 
      SET mtp_udfchar02 = NULL,
          mtp_udfchar04 = NULL,
          mtp_udfchar05 = NULL,
          mtp_udfchkbox04 = '+'
      WHERE mtp_org = mtp.mtp_org
        AND mtp_code = mtp.mtp_code
        AND mtp_revision = mtp.mtp_revision;
    END IF;
    IF cpeq != ipeq THEN
      UPDATE r5maintenancepatterns 
      SET mtp_udfchar02 = NULL,
          mtp_udfchar04 = NULL,
          mtp_udfchar05 = NULL
      WHERE mtp_org = mtp.mtp_org
        AND mtp_code = mtp.mtp_code
        AND mtp_revision = mtp.mtp_revision;
    END IF;
  END IF;

EXCEPTION
  WHEN err THEN
  RAISE_APPLICATION_ERROR (-20003, imsg);
  WHEN no_data_found THEN
  RAISE_APPLICATION_ERROR (-20003,
    'ERR/R5MAINTENANCEPATTERNS/25/Update/NoDataFound');
  WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20003,
    'ERR/R5MAINTENANCEPATTERNS/25/Update'
    ||Substr(SQLERRM, 1, 500));
END;
