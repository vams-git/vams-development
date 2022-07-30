DECLARE
  peq   R5PATTERNEQUIPMENT%ROWTYPE;
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

EXCEPTION
  WHEN err THEN
  RAISE_APPLICATION_ERROR (-20003, imsg);
  WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20003,
    'ERR R5PATTERNEQUIPMENT/20/Post Insert/'
    ||Substr(SQLERRM, 1, 500));
END;
