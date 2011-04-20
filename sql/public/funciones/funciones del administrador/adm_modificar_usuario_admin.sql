﻿CREATE OR REPLACE FUNCTION adm_modificar_usuario_admin(character varying[])
  RETURNS smallint AS
$BODY$
DECLARE
	datos ALIAS 	FOR $1;

	_id_usu_adm 	usuarios_administrativos.id_usu_adm%TYPE;
	_nom_usu_adm 	usuarios_administrativos.nom_usu_adm%TYPE;
	_ape_usu_adm 	usuarios_administrativos.ape_usu_adm%TYPE;
	_tel_usu_adm 	usuarios_administrativos.tel_usu_adm%TYPE;
	_id_tip_usu 	tipos_usuarios.id_tip_usu%TYPE;

	--Variable record
	_var_rec	record;

BEGIN
	_id_usu_adm	:= datos[1];
	_nom_usu_adm 	:= datos[2];
	_ape_usu_adm 	:= datos[3];
	_tel_usu_adm 	:= datos[4];
	_id_tip_usu 	:= datos[5];
	
	/* Si se encuentra el usuario administrativo se modifica*/
	SELECT INTO _var_rec * FROM usuarios_administrativos WHERE id_usu_adm = _id_usu_adm;
	IF FOUND THEN 

		/* Se modifica los datos del usuario administrativo */
		UPDATE usuarios_administrativos 
		SET 
			nom_usu_adm = _nom_usu_adm, 
			ape_usu_adm = _ape_usu_adm, 
			tel_usu_adm = _tel_usu_adm,
			id_tip_usu  = _id_tip_usu
			
		WHERE id_usu_adm = _id_usu_adm;

		/* La función se ejecutó exitosamente*/
		RETURN 0;

	ELSE     
		/* No existe el usuario administrativo a modificar */
		RETURN 1;
	END IF;

END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
COMMENT ON FUNCTION adm_modificar_usuario_admin(character varying[]) IS '
NOMBRE: adm_modificar_usuario_admin
TIPO: Function (store procedure)

PARAMETROS: Recibe 7 Parámetros
	1:  Identificador del usuario administrativo
	2:  Nombre del usuario administrativo
	3:  Apellido del usuario administrativo
	4:  Teléfono del usuario administrativo
	5:  Tipo de usuario

DESCRIPCION: 
	Modifica la información del usuario administrativo 

RETORNO:
	0: La función se ejecutó exitosamente
	1: Las contraseñas son diferentes
	2: Existe un usuario administrativo con el mismo login
	 
EJEMPLO DE LLAMADA:
	SELECT adm_modificar_usuario_admin(ARRAY[''1'', ''Lisseth'', ''Lozada'', ''04269150722'', ''1'']);

AUTOR DE CREACIÓN: Lisseth Lozada
FECHA DE CREACIÓN: 27/03/2011      
';

	