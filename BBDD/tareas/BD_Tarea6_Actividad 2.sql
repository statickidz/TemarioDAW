CREATE OR REPLACE TRIGGER restricciones_agentes
BEFORE INSERT OR UPDATE ON agentes
FOR EACH ROW
DECLARE
	mensaje VARCHAR2(1000);
	fallo	BOOLEAN;
BEGIN
	mensaje := '';
	fallo   := false;
	IF (:new.usuario = :new.clave) THEN
		mensaje := mensaje || '{El usuario y la clave de un agente no pueden ser iguales}';
		fallo   := true;
	END IF;
	IF (:new.habilidad < 0 or :new.habilidad > 9) THEN
		mensaje := mensaje || '{La habilidad de un agente debe estar comprendida entre 0 y 9 (ambos inclusive)}';
		fallo   := true;
	END IF;
	IF (:new.categoria < 0 or :new.categoria > 2) THEN
		mensaje := mensaje || '{La categoría de un agente sólo puede ser igual a 0, 1 o 2}';
		fallo   := true;
	END IF;
	IF (:new.oficina is not null and :new.categoria != 2) THEN
		mensaje := mensaje || '{Si un agente pertenece a una oficina directamente, su categoría debe ser igual 2}';
		fallo   := true;
	END IF;
	IF (:new.oficina is null and :new.categoria = 2) THEN
		mensaje := mensaje || '{Si un agente no pertenece a una oficina directamente, su categoría no puede ser 2}';
		fallo   := true;
	END IF;
	IF (:new.oficina is null and :new.familia is null) THEN
		mensaje := mensaje || '{No puede haber agentes que no pertenezcan a una oficina o a una familia}';
		fallo   := true;
	END IF;
	IF (:new.oficina is not null and :new.familia is not null) THEN
		mensaje := mensaje || '{No puede haber agentes que pertenezcan a una oficina y a una familia a la vez}';
		fallo   := true;
	END IF;
	IF (fallo = true) THEN
		RAISE_APPLICATION_ERROR(-20201, mensaje);
	END IF;
END;
/
