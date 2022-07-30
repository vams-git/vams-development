DECLARE
  peq   R5PATTERNEQUIPMENT%ROWTYPE;
  ceq   NUMBER;
  err   EXCEPTION;
  imsg  VARCHAR2(400);

BEGIN
  SELECT * INTO peq FROM R5PATTERNEQUIPMENT
  WHERE ROWID = :rowid;

  -- unmark inactive if eq is active
  IF peq.peq_status != 'I' THEN
    UPDATE R5MAINTENANCEPATTERNS
    SET   mtp_udfchkbox04 = NULL,
          mtp_udfchkbox05 = NULL
    WHERE mtp_org = peq.peq_mp_org
      AND mtp_code = peq.peq_mp
      AND mtp_revision = peq.peq_revision;
  END IF;

  IF peq.peq_status = 'I' THEN
    -- count other active eq
    SELECT Count(1) INTO ceq FROM R5PATTERNEQUIPMENT
    WHERE peq_mp_org = peq.peq_mp_org
      AND peq_mp = peq.peq_mp
      AND peq_revision = peq.peq_revision
      AND peq_object_org != peq.peq_object_org
      AND peq_object != peq.peq_object
      AND peq_status != 'I';

    -- maintain active stat if active eq > 0
    IF ceq > 0 THEN
      UPDATE R5MAINTENANCEPATTERNS
      SET   mtp_udfchkbox04 = NULL,
            mtp_udfchkbox05 = NULL
      WHERE mtp_org = peq.peq_mp_org
        AND mtp_code = peq.peq_mp
        AND mtp_revision = peq.peq_revision;
    END IF;

    -- mark inactive if there's no active eq
    IF ceq = 0 THEN
      UPDATE R5MAINTENANCEPATTERNS
      SET   mtp_udfchkbox04 = '+',
            mtp_udfchkbox05 = NULL
      WHERE mtp_org = peq.peq_mp_org
        AND mtp_code = peq.peq_mp
        AND mtp_revision = peq.peq_revision;
    END IF;
  END IF;

EXCEPTION
  WHEN err THEN
  RAISE_APPLICATION_ERROR (-20003, imsg);
  WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20003,
    'ERR R5PATTERNEQUIPMENT/20/Post Update/'
    ||Substr(SQLERRM, 1, 500));
END;
