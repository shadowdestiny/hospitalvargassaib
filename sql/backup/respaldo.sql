--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.3
-- Dumped by pg_dump version 9.0.3
-- Started on 2011-10-13 22:49:51

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 470 (class 2612 OID 11574)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 363 (class 1247 OID 18821)
-- Dependencies: 6 1742
-- Name: t_validar_usuarios; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE t_validar_usuarios AS (
	id_usu integer,
	nom_usu text,
	ape_usu text,
	pas_usu text,
	log_usu text,
	tel_usu text,
	id_tip_usu integer,
	id_tip_usu_usu integer,
	cod_tip_usu text,
	str_trans text,
	des_tip_usu text
);


ALTER TYPE public.t_validar_usuarios OWNER TO postgres;

--
-- TOC entry 2337 (class 0 OID 0)
-- Dependencies: 363
-- Name: TYPE t_validar_usuarios; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE t_validar_usuarios IS '
NOMBRE: t_validar_usuarios
TIPO: TIPO
	
CREADOR: Luis Raul Marin	
MODIFICADO: 
FECHA: 20/03/2011
';


--
-- TOC entry 24 (class 1255 OID 18037)
-- Dependencies: 470 6
-- Name: adm_eliminar_medico(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION adm_eliminar_medico(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	datos ALIAS 	FOR $1;
	_id_doc		doctores.id_doc%TYPE;
	_nom_doc 	doctores.nom_doc%TYPE;	
BEGIN

	_id_doc		:= datos[1];

	-- Si existe un paciente que tenga una id del doctor retorna 2
	IF (EXISTS(SELECT 1 FROM pacientes JOIN doctores USING(id_doc) WHERE id_doc = _id_doc))THEN
		RETURN 2;
	END IF;
			
	IF EXISTS(SELECT 1 FROM doctores WHERE id_doc = _id_doc)THEN
		/* El usuario administrativo puede ser eliminado */
					
			/*Eliminando doctor*/	

			DELETE FROM doctores 
			WHERE 
			id_doc = _id_doc
			;
						

			-- La función se ejecutó exitosamente
			RETURN 1;
	ELSE
		RETURN 0;
	END IF;
	/*EXCEPTION
	WHEN foreign_key_violation THEN
		IF (STRPOS(SQLERRM,))THEN
		--RAISE EXCEPTION '%','';
		 --RAISE LOG '%, via LOG','msg';
		--RAISE EXCEPTION  '%',SQLERRM;
	RETURN 2;*/
	
END;$_$;


ALTER FUNCTION public.adm_eliminar_medico(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2338 (class 0 OID 0)
-- Dependencies: 24
-- Name: FUNCTION adm_eliminar_medico(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION adm_eliminar_medico(character varying[]) IS '
NOMBRE: adm_eliminar_medico
TIPO: Function (store procedure)

PARAMETROS: Recibe 1 Parámetros
	1:  Id del usuario doctor
	
DESCRIPCION: 
	Almacena la información del doctor

RETORNO:
	1: La función se ejecutó exitosamente.
	0: Existe un usuario administrativo con el mismo login.
	2: No se puede eliminar este doctor porque tiene pacientes asociados.
	 
EJEMPLO DE LLAMADA:
	SELECT adm_modificar_medico(ARRAY[''1'']);

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 10/05/2011

';


--
-- TOC entry 27 (class 1255 OID 17896)
-- Dependencies: 470 6
-- Name: adm_eliminar_usuario_admin(character varying); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION adm_eliminar_usuario_admin(character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	
	--Variables
	_id_usu_adm 	ALIAS FOR $1;
	--_consulta 	varchar := '';

	--Variable record
	--_registro_usu	record;

BEGIN

	/*_consulta := 'SELECT * FROM usuarios_administrativos WHERE id_usu_adm IN (' || _ids_usu_eli || ')';*/


	/* Se obtienen los datos de cada uno de los usuario eliminados */
	/*FOR _registro_usu IN EXECUTE _consulta 
	LOOP*/
	       /* Se borran los registros asociados a los usuarios */
	       --DELETE FROM usuarios_administrativos WHERE id_usu_adm = _registro_usu.id_usu_adm;

	/*END LOOP;
	RETURN 0;*/

	IF EXISTS(SELECT 1 FROM usuarios_administrativos WHERE id_usu_adm = _id_usu_adm::INTEGER)THEN
		DELETE FROM usuarios_administrativos WHERE id_usu_adm = _id_usu_adm::INTEGER;
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;

	
END;$_$;


ALTER FUNCTION public.adm_eliminar_usuario_admin(character varying) OWNER TO desarrollo_g;

--
-- TOC entry 2339 (class 0 OID 0)
-- Dependencies: 27
-- Name: FUNCTION adm_eliminar_usuario_admin(character varying); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION adm_eliminar_usuario_admin(character varying) IS '
NOMBRE: adm_eliminar_usuario_admin
TIPO: Function (store procedure)

PARAMETROS: Recibe 7 Parámetros
	0:  El usuario no se encuentra registrado en el sistema
	1:  Se eliminó el usuario con éxito	

DESCRIPCION: 
	Elimina la información del usuario administrativo 

RETORNO:
	0: La función se ejecutó exitosamente
	
	 
EJEMPLO DE LLAMADA:
	SELECT adm_eliminar_usuario_admin(''1,2'');

AUTOR DE CREACIÓN: Lisseth Lozada
FECHA DE CREACIÓN: 27/03/2011      

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 22/04/2011  
DESCRIPCIÓN: Modificación de las estructuras de control
';


--
-- TOC entry 21 (class 1255 OID 18022)
-- Dependencies: 6 470
-- Name: adm_modificar_medico(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION adm_modificar_medico(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	datos ALIAS 	FOR $1;
	_id_doc		doctores.id_doc%TYPE;
	_ced_doc	doctores.ced_doc%TYPE;
	_nom_doc 	doctores.nom_doc%TYPE;
	_ape_doc 	doctores.ape_doc%TYPE;
	_pas_doc	doctores.pas_doc%TYPE;
	_log_doc	doctores.log_doc%TYPE;
	_tel_doc 	doctores.tel_doc%TYPE;
	_cor_doc 	doctores.cor_doc%TYPE;
	_cen_sal 	centro_salud_doctores.id_cen_sal%TYPE;
	_trans_doc	TEXT; 		-- transacciones a las cuales tiene permiso el doctor, o mejor dicho niveles de acceso
	_arr_trans_doc	INTEGER[]; 	-- transacciones a las cuales tiene permiso el doctor, o mejor dicho niveles de acceso
	_vr_tip_usu 	RECORD;

	_id_tip_usu_usu	INTEGER;
	
BEGIN

	_id_doc		:= datos[1];
	_log_doc 	:= datos[2];
	_ced_doc	:= datos[3];
	_nom_doc 	:= datos[4];
	_ape_doc 	:= datos[5];
	_pas_doc	:= md5(datos[6]);		
	_tel_doc 	:= datos[7];
	_cor_doc 	:= datos[8];
	_cen_sal 	:= datos[9];
	_trans_doc	:= datos[10];
	
	
	IF EXISTS(SELECT 1 FROM doctores WHERE id_doc = _id_doc)THEN
		/* El usuario administrativo puede ser registrado */
		IF NOT EXISTS (SELECT 1 FROM doctores WHERE log_doc = _log_doc AND id_doc <> _id_doc) THEN     					
			/*Inserta registro en la tabla usuarios_administrativos*/	

			IF NOT EXISTS(SELECT 1 FROM doctores WHERE ced_doc = _ced_doc AND id_doc <> _id_doc) THEN     					
				UPDATE doctores SET 
					
					nom_doc = _nom_doc,
					ape_doc = _ape_doc,
					pas_doc = _pas_doc,
					ced_doc	= _ced_doc,
					log_doc = _log_doc,
					tel_doc = _tel_doc,
					cor_doc = _cor_doc					
				
				WHERE id_doc = _id_doc;

				/*Elimino el centro de salud del doctor y lo vuelvo a insertar*/
				DELETE FROM centro_salud_doctores WHERE id_doc = _id_doc;
				INSERT INTO centro_salud_doctores(
					id_cen_sal, 
					id_doc, 
					otr_cen_sal
				)
				VALUES 
				(
					_cen_sal, 
					_id_doc, 
					NULL
				);
				
				/* Insertando las transacciones del usuario*/
				_id_tip_usu_usu := (SELECT id_tip_usu_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc);
				DELETE FROM transacciones_usuarios WHERE id_tip_usu_usu = _id_tip_usu_usu;	
				
				_arr_trans_doc := STRING_TO_ARRAY(_trans_doc,',');
						
				IF (ARRAY_UPPER(_arr_trans_doc,1) > 0)THEN							
					FOR i IN 1..(ARRAY_UPPER(_arr_trans_doc,1)) LOOP
						INSERT INTO transacciones_usuarios(
							id_tip_usu_usu,
							id_tip_tra
						)
						VALUES
						(					
							_id_tip_usu_usu,
							_arr_trans_doc[i]
						);
					END LOOP;
				END IF;
			ELSE
				RETURN 3;
			END IF;

				-- La función se ejecutó exitosamente
			RETURN 1;
			
		
		ELSE
			-- Existe un usuario administrativo con el mismo login
			RETURN 2;
		END IF;
	ELSE
		RETURN 0;
	END IF;

END;$_$;


ALTER FUNCTION public.adm_modificar_medico(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2340 (class 0 OID 0)
-- Dependencies: 21
-- Name: FUNCTION adm_modificar_medico(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION adm_modificar_medico(character varying[]) IS '
NOMBRE: adm_modificar_medico
TIPO: Function (store procedure)

PARAMETROS: Recibe 7 Parámetros
	1:  Id del usuario doctor
	2:  Login del usuario doctor
	3:  Cédula del usuario doctor
	4:  Nombre del usuario doctor
	5:  Apellido del usuario doctor
	6:  Password del usuario doctor	
	7:  Teléfono del usuario doctor
	8:  Correo Electrónico del usuario doctor
	9:  Centro de salud del usuario doctor 
	10: Tipo de usuario (id_tip_usu_usu Usuarios, desde la tabla tipos_usuarios_usuarios)
	
DESCRIPCION: 
	Almacena la información del doctor

RETORNO:

	0: Existe un usuario administrativo con el mismo login
	1: La función se ejecutó exitosamente
	2: Ya existe un usuario administrativo con este login
	3: Ya existe un usuario administrativo con la misma cédula
	
	 
EJEMPLO DE LLAMADA:
	SELECT adm_modificar_medico(ARRAY[''1'',''Lisseth'', ''Lozada'', ''123'', ''llozada'',''04269150722'',''risusefu@gmail.com'',''4'',''1,2,3'']);

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/05/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 24/06/2011
';


--
-- TOC entry 25 (class 1255 OID 17895)
-- Dependencies: 6 470
-- Name: adm_modificar_usuario_admin(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION adm_modificar_usuario_admin(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	datos ALIAS 	FOR $1;

	_id_usu_adm 	usuarios_administrativos.id_usu_adm%TYPE;
	_nom_usu_adm 	usuarios_administrativos.nom_usu_adm%TYPE;
	_pas_usu_adm 	usuarios_administrativos.pas_usu_adm%TYPE;
	_ape_usu_adm 	usuarios_administrativos.ape_usu_adm%TYPE;
	_tel_usu_adm 	usuarios_administrativos.tel_usu_adm%TYPE;
	_log_usu_adm 	usuarios_administrativos.log_usu_adm%TYPE;

	--Variable record
	_var_rec	record;

BEGIN
	_id_usu_adm	:= datos[1];
	_log_usu_adm	:= datos[2];
	_nom_usu_adm 	:= datos[3];
	_ape_usu_adm 	:= datos[4];
	_pas_usu_adm 	:= md5(datos[5]);
	_tel_usu_adm 	:= datos[6];	

	/* Si se encuentra el usuario administrativo se modifica*/
	IF NOT EXISTS(SELECT 1 FROM usuarios_administrativos WHERE id_usu_adm <> _id_usu_adm AND log_usu_adm = _log_usu_adm)THEN
	
		SELECT INTO _var_rec * FROM usuarios_administrativos WHERE id_usu_adm = _id_usu_adm;
		IF FOUND THEN 

			/* Se modifica los datos del usuario administrativo */
			UPDATE usuarios_administrativos 
			SET 
				nom_usu_adm = _nom_usu_adm, 
				ape_usu_adm = _ape_usu_adm, 
				pas_usu_adm = _pas_usu_adm,
				tel_usu_adm = _tel_usu_adm,
				log_usu_adm = _log_usu_adm
				
			WHERE id_usu_adm = _id_usu_adm;

			/* La función se ejecutó exitosamente*/
			RETURN 1;

		ELSE     
			/* No existe el usuario administrativo a modificar */
			RETURN 0;
		END IF;
	ELSE
		RETURN 2;
	END IF;

END;$_$;


ALTER FUNCTION public.adm_modificar_usuario_admin(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2341 (class 0 OID 0)
-- Dependencies: 25
-- Name: FUNCTION adm_modificar_usuario_admin(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

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
	2: Existe un usuario administrativo con el mismo login
	1: La función se ejecutó exitosamente.
	0: No existe el usuario
	 
EJEMPLO DE LLAMADA:
	SELECT adm_modificar_usuario_admin(ARRAY[''1'',''llozasa'' ''Lisseth'', ''Lozada'',''123456contraseña'', ''04269150722'']);

AUTOR DE CREACIÓN: Lisseth Lozada
FECHA DE CREACIÓN: 27/03/2011   

AUTOR DE MODIFICACIÓN: Luis Marin
FECHA DE CREACIÓN: 22/04/2011    
DESCRIPCIÓN: Validación de log del usuario   
';


--
-- TOC entry 19 (class 1255 OID 18012)
-- Dependencies: 470 6
-- Name: adm_registrar_medico(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION adm_registrar_medico(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	datos ALIAS 	FOR $1;

	_nom_doc 	doctores.nom_doc%TYPE;
	_ape_doc 	doctores.ape_doc%TYPE;
	_ced_doc	doctores.ced_doc%TYPE;
	_pas_doc	doctores.pas_doc%TYPE;
	_log_doc	doctores.log_doc%TYPE;
	_tel_doc 	doctores.tel_doc%TYPE;
	_cor_doc 	doctores.cor_doc%TYPE;
	_cen_sal 	centro_salud_doctores.id_cen_sal%TYPE;
	_trans_doc	TEXT; 	-- transacciones a las cuales tiene permiso el doctor, o mejor dicho niveles de acceso
	_arr_trans_doc	INTEGER[]; -- transacciones a las cuales tiene permiso el doctor, o mejor dicho niveles de acceso
	_vr_tip_usu 	RECORD;
	
	
BEGIN

	_nom_doc 	:= datos[1];
	_ape_doc 	:= datos[2];
	_ced_doc	:= datos[3];
	_pas_doc	:= md5(datos[4]);	
	_log_doc 	:= datos[5];
	_tel_doc 	:= datos[6];
	_cor_doc 	:= datos[7];
	_cen_sal 	:= datos[8];
	_trans_doc	:= datos[9];
		
	/* El usuario administrativo puede ser registrado */
	IF NOT EXISTS (SELECT 1 FROM doctores WHERE log_doc = _log_doc) THEN     		
		/*Comprobando si existe un doctor con la cedula insertado por parametros*/
		IF NOT EXISTS (SELECT 1 FROM doctores WHERE ced_doc = _ced_doc) THEN     		
			/*Inserta registro en la tabla usuarios_administrativos*/
			INSERT INTO doctores
			(
				nom_doc,
				ape_doc,
				ced_doc,
				pas_doc,
				log_doc,
				tel_doc,
				cor_doc,			
				fec_reg_doc			
			)
			VALUES 
			(
				_nom_doc,
				_ape_doc,
				_ced_doc,
				_pas_doc,
				_log_doc,
				_tel_doc,
				_cor_doc,			
				NOW()			
			);

			INSERT INTO centro_salud_doctores(
				id_cen_sal, 
				id_doc, 
				otr_cen_sal
			)
			VALUES 
			(
				_cen_sal, 
				(CURRVAL('doctores_id_doc_seq')),
				null
			);
    		
			
			/*Insertando tipo de usuario como administrador*/
			INSERT INTO tipos_usuarios__usuarios(
				id_doc ,
				id_tip_usu
			)
			VALUES
			(
				(CURRVAL('doctores_id_doc_seq')),
				(SELECT id_tip_usu FROM tipos_usuarios WHERE cod_tip_usu = 'med')
			);

			/* Insertando las transacciones del usuario*/
			_arr_trans_doc := STRING_TO_ARRAY(_trans_doc,',');
			IF (ARRAY_UPPER(_arr_trans_doc,1) > 0)THEN
				FOR i IN 1..(ARRAY_UPPER(_arr_trans_doc,1)) LOOP
					INSERT INTO transacciones_usuarios(
						id_tip_usu_usu,
						id_tip_tra
					)
					VALUES
					(
						(CURRVAL('tipos_usuarios__usuarios_id_tip_usu_usu_seq')),
						_arr_trans_doc[i]
					);
				END LOOP;
			END IF;

			-- La función se ejecutó exitosamente
			RETURN 1;
		ELSE
			RETURN 2;-- Existe un usuario medico con la misma cedula.
		END IF;
	
	ELSE
		-- Existe un usuario administrativo con el mismo login
		RETURN 0;
	END IF;

END;$_$;


ALTER FUNCTION public.adm_registrar_medico(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2342 (class 0 OID 0)
-- Dependencies: 19
-- Name: FUNCTION adm_registrar_medico(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION adm_registrar_medico(character varying[]) IS '
NOMBRE: adm_registrar_medico
TIPO: Function (store procedure)

PARAMETROS: Recibe 6 Parámetros
	1:  Nombre del usuario doctor
	2:  Apellido del usuario doctor
	3:  Cédula del doctor
	4:  Password del usuario doctor	
	5:  Login del usuario doctor
	6:  Teléfono del usuario doctor
	7:  Correo Electrónico del usuario doctor
	8:  Centro de salud del usuario doctor
	9:  Tipo de usuario (id_tip_usu_usu Usuarios, desde la tabla tipos_usuarios_usuarios)

DESCRIPCION: 
	Almacena la información del usuario administrativo 

RETORNO:
	1: La función se ejecutó exitosamente.
	0: Existe un usuario administrativo con el mismo login.
	2: Existe un usuario medico con la misma cedula.
	 
EJEMPLO DE LLAMADA:
	SELECT adm_registrar_medico(ARRAY[''Lisseth'', ''Lozada'',''123456'', ''123'', ''llozada'',''04269150722'',''risusefu@gmail.com'',''7'',''1,2,3'']);

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 04/05/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 24/06/2011
';


--
-- TOC entry 26 (class 1255 OID 17894)
-- Dependencies: 470 6
-- Name: adm_registrar_usuario_admin(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION adm_registrar_usuario_admin(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	datos ALIAS 	FOR $1;

	_nom_usu_adm 	usuarios_administrativos.nom_usu_adm%TYPE;
	_ape_usu_adm 	usuarios_administrativos.ape_usu_adm%TYPE;
	_pas_usu_adm	usuarios_administrativos.pas_usu_adm%TYPE;
	_log_usu_adm 	usuarios_administrativos.log_usu_adm%TYPE;
	_tel_usu_adm 	usuarios_administrativos.tel_usu_adm%TYPE;
	_vr_tip_usu 	RECORD;
	
BEGIN

	_nom_usu_adm 	:= datos[1];
	_ape_usu_adm 	:= datos[2];
	_pas_usu_adm	:= md5(datos[3]);	
	_log_usu_adm 	:= datos[4];
	_tel_usu_adm 	:= datos[5];	
	
	

	/* El usuario administrativo puede ser registrado */
	IF NOT EXISTS (SELECT 1 FROM usuarios_administrativos WHERE log_usu_adm = _log_usu_adm) THEN     		
		
		/*Inserta registro en la tabla usuarios_administrativos*/
		INSERT INTO usuarios_administrativos
		(
			nom_usu_adm,
			ape_usu_adm,
			pas_usu_adm,
			log_usu_adm,
			tel_usu_adm,			
			fec_reg_usu_adm,
			adm_usu
		)
		VALUES 
		(
			_nom_usu_adm,
			_ape_usu_adm,
			_pas_usu_adm,
			_log_usu_adm,
			_tel_usu_adm,			
			NOW(),
			TRUE
		);		
		
		/*Insertando tipo de usuario como administrador*/
		INSERT INTO tipos_usuarios__usuarios(
			id_usu_adm,
			id_tip_usu
		)VALUES
		(
			(CURRVAL('usuarios_administrativos_id_usu_adm_seq')),
			(SELECT id_tip_usu FROM tipos_usuarios WHERE cod_tip_usu = 'adm')
		);

		-- La función se ejecutó exitosamente
		RETURN 1;
		
	
	ELSE
		-- Existe un usuario administrativo con el mismo login
		RETURN 0;
	END IF;

END;$_$;


ALTER FUNCTION public.adm_registrar_usuario_admin(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2343 (class 0 OID 0)
-- Dependencies: 26
-- Name: FUNCTION adm_registrar_usuario_admin(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION adm_registrar_usuario_admin(character varying[]) IS '
NOMBRE: adm_registrar_usuario_admin
TIPO: Function (store procedure)

PARAMETROS: Recibe 7 Parámetros
	1:  Nombre del usuario administrativo
	2:  Apellido del usuario administrativo
	3:  Password del usuario administrativo
	4:  Repetición del Password del usuario administrativo
	5:  Login del usuario administrativo
	6:  Teléfono del usuario administrativo
	7:  Tipo de usuario

DESCRIPCION: 
	Almacena la información del usuario administrativo 

RETORNO:
	1: La función se ejecutó exitosamente
	0: Existe un usuario administrativo con el mismo login
	 
EJEMPLO DE LLAMADA:
	SELECT adm_registrar_usuario_admin(ARRAY[''Lisseth'', ''Lozada'', ''123'', ''llozada'',''04269150722'']);

AUTOR DE CREACIÓN: Lisseth Lozada
FECHA DE CREACIÓN: 27/03/2011

';


--
-- TOC entry 22 (class 1255 OID 19239)
-- Dependencies: 470 6
-- Name: formato_campo_xml(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION formato_campo_xml(character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_nomcolumna 	ALIAS FOR $1;
	_valoract 	ALIAS FOR $2;
	_valorant 	ALIAS FOR $3;
	_campoxml 	VARCHAR;

BEGIN
	_campoxml := '<campo nombre=' || CHR(34) || _nomcolumna || CHR(34) || '><actual>' || _valoract || '</actual><anterior>' || _valorant || '</anterior></campo>';

	RETURN _campoxml;

END;$_$;


ALTER FUNCTION public.formato_campo_xml(character varying, character varying, character varying) OWNER TO desarrollo_g;

--
-- TOC entry 2344 (class 0 OID 0)
-- Dependencies: 22
-- Name: FUNCTION formato_campo_xml(character varying, character varying, character varying); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION formato_campo_xml(character varying, character varying, character varying) IS '
NOMBRE: formato_campo_xml
TIPO: Function (store procedure)

PARAMETROS: Recibe 3 Parámetros
	1:  Nombre del campo
	2:  Valor del campo actual
	3:  Valor del campo anterior
	
DESCRIPCION: 
	Arma el xml para las transacciones

RETORNO:
	Retorna una cadena xml
	 
EJEMPLO DE LLAMADA:
	SELECT formato_campo_xml(''nombre de la columna'', ''valor actual'', ''valor anterior'')

AUTOR DE CREACIÓN: Lisseth Lozada
FECHA DE CREACIÓN: 08/08/2011
';


--
-- TOC entry 18 (class 1255 OID 18866)
-- Dependencies: 470 6
-- Name: med_eliminar_historial(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_eliminar_historial(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	
	--Variables
	_data 		ALIAS FOR $1;
	_id_his		historiales_pacientes.id_his%TYPE;
	_id_doc		historiales_pacientes.id_doc%TYPE;

	_tra_usu	transacciones.cod_tip_tra%TYPE;

	_valorcampos 	VARCHAR := '';
	_reg_ant	RECORD;
	_reg_usu	RECORD;
	_reg_tra	RECORD;

BEGIN
	_id_his 	:= _data[1];
	_id_doc 	:= _data[2];
	_tra_usu	:= _data[3];
	
	IF EXISTS(SELECT 1 FROM historiales_pacientes WHERE id_his = _id_his::INTEGER)THEN

		/*Busco el registro anterior del historial del paciente*/
		SELECT nom_pac,ape_pac,ced_pac,des_his,des_adi_pac_his,fec_his INTO _reg_ant
		FROM historiales_pacientes LEFT JOIN pacientes USING(id_pac) 
		WHERE id_his = _id_his;

		/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
		_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><eliminacion_del_historial_paciente>
			 <tabla nombre="historiales_pacientes">';
			_valorcampos := _valorcampos || 
			formato_campo_xml('Nombre Paciente', 		'ninguno', 	coalesce(_reg_ant.nom_pac::text,'ninguno'))||
			formato_campo_xml('Apellido Paciente',  	'ninguno', 	coalesce(_reg_ant.ape_pac::text,'ninguno'))||
			formato_campo_xml('Cédula Paciente', 		'ninguno', 	coalesce(_reg_ant.ced_pac::text,'ninguno'))||
			formato_campo_xml('Descripción de la Historia', 'ninguno', 	coalesce(_reg_ant.des_his::text,'ninguno'))||
			formato_campo_xml('Descripción Adicional', 	'ninguno', 	coalesce(_reg_ant.des_adi_pac_his::text,'ninguno'))||
			formato_campo_xml('Fecha de Historia', 		'ninguno', 	coalesce(_reg_ant.fec_his::text,'ninguno'));
			/*ªª Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';
		_valorcampos := _valorcampos || '</eliminacion_del_historial_paciente>';	

			
		/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
		SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

		/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
		SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
		
		INSERT INTO auditoria_transacciones
		(
			fec_aud_tra, 
			id_tip_usu_usu,
			id_tip_tra, 
			data_xml
		)
		VALUES 
		(
			 NOW(), 
			_reg_usu.id_tip_usu_usu, 
			_reg_tra.id_tip_tra, 
			_valorcampos::XML
		);
		
		DELETE FROM historiales_pacientes WHERE id_his = _id_his::INTEGER;
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;

	
END;$_$;


ALTER FUNCTION public.med_eliminar_historial(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2345 (class 0 OID 0)
-- Dependencies: 18
-- Name: FUNCTION med_eliminar_historial(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_eliminar_historial(character varying[]) IS '
NOMBRE: med_eliminar_historial
TIPO: Function (store procedure)

PARAMETROS: Recibe 2 Parámetros
	1:  Id del Historial a eliminar
	2:  Id del doctor que se encuentra actualmente logueado	
	3:  Código de la transacción
DESCRIPCION: 
	Elimina la información del usuario administrativo 

RETORNO:
	1: La función se ejecutó exitosamente
	0: No existe el historial a eliminar

EJEMPLO DE LLAMADA:
	SELECT adm_eliminar_usuario_admin(ARRAY[''16'',''32'',''EHP'']);


AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 01/07/2011 
DESCRIPCIÓN: Eliminacion de los historicos

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 23/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 23 (class 1255 OID 19261)
-- Dependencies: 6 470
-- Name: med_eliminar_micosis_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_eliminar_micosis_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	
	--Variables
	_data 		ALIAS FOR $1;
	_id_tip_mic_pac	tipos_micosis_pacientes.id_tip_mic_pac%TYPE;
	_id_doc		historiales_pacientes.id_doc%TYPE;

	_tra_usu	transacciones.cod_tip_tra%TYPE;

	_valorcampos 	VARCHAR := '';
	_reg_ant	RECORD;
	_reg_usu	RECORD;
	_reg_tra	RECORD;

BEGIN
	_id_tip_mic_pac 	:= _data[1];
	_id_doc 		:= _data[2];
	--_tra_usu		:= _data[3];

	IF EXISTS(SELECT 1 FROM tipos_micosis_pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac) THEN
		DELETE FROM tipos_micosis_pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac;
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
	
END;$_$;


ALTER FUNCTION public.med_eliminar_micosis_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2346 (class 0 OID 0)
-- Dependencies: 23
-- Name: FUNCTION med_eliminar_micosis_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_eliminar_micosis_paciente(character varying[]) IS '
NOMBRE: med_eliminar_micosis_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 2 Parámetros
	1:  Tipo de enfermedad del paciente
	2:  Id del doctor que se encuentra actualmente logueado	
	3:  Código de la transacción
DESCRIPCION: 
	Elimina la información del usuario administrativo 

RETORNO:
	1: La función se ejecutó exitosamente
	0: No existe la enfermedad a  eliminar

EJEMPLO DE LLAMADA:
	SELECT adm_eliminar_usuario_admin(ARRAY[''16'',''32'']);


AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 04/09/2011 
DESCRIPCIÓN: Eliminación de enfermedades del paciente.

';


--
-- TOC entry 29 (class 1255 OID 18766)
-- Dependencies: 470 6
-- Name: med_eliminar_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_eliminar_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	
	--Variables
	_data 		ALIAS FOR $1;
	_id_pac		pacientes.id_pac%TYPE;
	_id_doc		doctores.id_doc%TYPE;
	_tra_usu	transacciones.cod_tip_tra%TYPE;

	_valorcampos 	VARCHAR := '';
	_des_ant_per_ant VARCHAR := '';	

	_reg_pac	RECORD;
	_reg_ant	RECORD;
	_reg_usu	RECORD;
	_reg_tra	RECORD;

BEGIN
	_id_pac 	:= _data[1];
	_id_doc 	:= _data[2];
	_tra_usu	:= _data[3];
	
	IF EXISTS(SELECT 1 FROM pacientes WHERE id_pac = _id_pac::INTEGER)THEN

		/*Busco el registro anterior del paciente*/
		SELECT 	id_pac,ape_pac,nom_pac,ced_pac,fec_nac_pac,tel_hab_pac,tel_cel_pac,ciu_pac,id_pai,id_est,id_mun, 
			CASE 
				WHEN nac_pac = '1' THEN 'Venezolano' ELSE 'Extranjero' 
			END AS nac_pac,
			CASE 
				WHEN ocu_pac = '1' THEN 'Profesional'
				WHEN ocu_pac = '2' THEN 'Técnico'
				WHEN ocu_pac = '3' THEN 'Obrero'
				WHEN ocu_pac = '4' THEN 'Agricultor'
				WHEN ocu_pac = '5' THEN 'Jardinero'
				WHEN ocu_pac = '6' THEN 'Otro'
			END AS ocu_pac  INTO _reg_pac
		FROM pacientes 
		WHERE id_pac = _id_pac;
		
				
		/*Busco la descripción del país, estado y municipio*/
		SELECT des_pai, des_est, des_mun INTO _reg_ant
		FROM paises p
			LEFT JOIN estados e ON(p.id_pai = e.id_pai)
			LEFT JOIN municipios m ON(e.id_est = m.id_est)
		WHERE p.id_pai = _reg_pac.id_pai
			AND e.id_est = _reg_pac.id_est
			AND m.id_mun = _reg_pac.id_mun;

		/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
		_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><eliminacion_de_pacientes>
				 <tabla nombre="pacientes">';
				_valorcampos := _valorcampos || 
				formato_campo_xml('ID', 		'ninguno', 	coalesce(_reg_pac.id_pac::text, 'ninguno'))||
				formato_campo_xml('Nombre',  		'ninguno', 	coalesce(_reg_pac.nom_pac::text, 'ninguno'))||
				formato_campo_xml('Apellido', 		'ninguno', 	coalesce(_reg_pac.ape_pac::text, 'ninguno'))||
				formato_campo_xml('Cédula', 		'ninguno', 	coalesce(_reg_pac.ced_pac::text, 'ninguno'))||  
				formato_campo_xml('Fecha Nacimiento', 	'ninguno', 	coalesce(_reg_pac.fec_nac_pac::text, 'ninguno'))||  
				formato_campo_xml('Nacionalidad', 	'ninguno', 	coalesce(_reg_pac.nac_pac::text, 'ninguno'))||  
				formato_campo_xml('Teléfono Habitación','ninguno', 	coalesce(_reg_pac.tel_hab_pac::text, 'ninguno'))||
				formato_campo_xml('Teléfono Célular', 	'ninguno', 	coalesce(_reg_pac.tel_cel_pac::text, 'ninguno'))|| 
				formato_campo_xml('Ocupación', 		'ninguno', 	coalesce(_reg_pac.ocu_pac::text, 'ninguno'))||
				formato_campo_xml('País', 		'ninguno', 	coalesce(_reg_ant.des_pai::text, 'ninguno'))||
				formato_campo_xml('Estado', 		'ninguno', 	coalesce(_reg_ant.des_est::text, 'ninguno'))||
				formato_campo_xml('Municipio', 		'ninguno', 	coalesce(_reg_ant.des_mun::text, 'ninguno'))||
				formato_campo_xml('Ciudad', 		'ninguno', 	coalesce(_reg_pac.ciu_pac::text, 'ninguno'));  
			/*ªª Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';

			/*Busco el registro anterior del nombre antecedente personal*/
			FOR _reg_ant IN (SELECT nom_ant_per FROM antecedentes_pacientes LEFT JOIN antecedentes_personales USING(id_ant_per) WHERE id_pac = _id_pac) LOOP
				_des_ant_per_ant := _des_ant_per_ant || _reg_ant.nom_ant_per || ' ,';
			END LOOP;

			/* Se le quita la última de las comas a la variable */
			IF length(_des_ant_per_ant) > 0 THEN
				_des_ant_per_ant := substr(_des_ant_per_ant, 1, length(_des_ant_per_ant) - 1);
			END IF;

			/* Se identifica la tabla en el formato xml */
			_valorcampos := _valorcampos || '<tabla nombre="antecedentes_pacientes">';
			/* Se completa el tag con el valor del campo */
				_valorcampos := _valorcampos || 
				formato_campo_xml('Antecedentes Personales', 'ninguno', coalesce(_des_ant_per_ant::text));
			/* Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';
			
		_valorcampos := _valorcampos || '</eliminacion_de_pacientes>';	
		
			
		/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
		SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

		/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
		SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
		
		INSERT INTO auditoria_transacciones
		(
			fec_aud_tra, 
			id_tip_usu_usu,
			id_tip_tra, 
			data_xml
		)
		VALUES 
		(
			 NOW(), 
			_reg_usu.id_tip_usu_usu, 
			_reg_tra.id_tip_tra, 
			_valorcampos::XML
		);

		DELETE FROM pacientes WHERE id_pac = _id_pac::INTEGER;
		
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;

	
END;$_$;


ALTER FUNCTION public.med_eliminar_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2347 (class 0 OID 0)
-- Dependencies: 29
-- Name: FUNCTION med_eliminar_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_eliminar_paciente(character varying[]) IS '
NOMBRE: med_eliminar_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 2 Parámetros
	1:  Id del paciente a eliminar
	2:  Id del doctor que se encuentra actualmente logueado	
	3:  Código de la transaccion
	
DESCRIPCION: 
	Elimina la información del usuario administrativo 

RETORNO:
	1: La función se ejecutó exitosamente
	0: No existe el paciente a eliminar

EJEMPLO DE LLAMADA:
	SELECT adm_eliminar_usuario_admin(ARRAY[''1'',''2'',''EP'']);


AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 22/04/2011 
DESCRIPCIÓN: Eliminacion de los pacientes

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 21/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 37 (class 1255 OID 19193)
-- Dependencies: 6 470
-- Name: med_insertar_micosis_pacientes(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_insertar_micosis_pacientes(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	_id_his			historiales_pacientes.id_his%TYPE;
		
	_id_tip_mic		tipos_micosis.id_tip_mic%TYPE;
	_str_enf_pac		TEXT;
	_str_les		TEXT;
	_str_tip_est_mic	TEXT;
	
	_str		TEXT;	
		
	_id_doc		doctores.id_doc%TYPE;
	
	_arr_1	INTEGER[];	
	_arr_2	INTEGER[];
	_arr_3	TEXT[];	

	_id_tip_mic_pac	tipos_micosis_pacientes.id_tip_mic_pac%TYPE;
	
BEGIN


	-- pacientes
	_id_his			:= _datos[1];
	_id_tip_mic		:= _datos[2];
	_str_enf_pac		:= _datos[3];
	_str_les		:= _datos[4];	
	_str_tip_est_mic	:= _datos[5];	
		
	_id_doc			:= _datos[6];	
	
	-- tipos de micosis del paciente
	IF NOT EXISTS  (SELECT 1 FROM tipos_micosis_pacientes WHERE id_his = _id_his AND id_tip_mic = _id_tip_mic) THEN
		
		INSERT INTO tipos_micosis_pacientes(
			id_tip_mic,
			id_his
		) VALUES (
			_id_tip_mic,
			_id_his
		);
		_id_tip_mic_pac:= CURRVAL('tipos_micosis_pacientes_id_tip_mic_pac_seq');			
	ELSE 
		RETURN 0;
	END IF;

	-- enfermedades del paciente
	--DELETE FROM enfermedades_paciente WHERE id_tip_mic_pac = _id_tip_mic_pac;

	_arr_1 := STRING_TO_ARRAY(_str_enf_pac,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP
			INSERT INTO enfermedades_pacientes (
				id_tip_mic_pac,
				id_enf_mic					
			) VALUES (
				_id_tip_mic_pac,
				_arr_1[i]
			);
		END LOOP;
	END IF;

	-- tipo de consulta del paciente referidos al historico
	--DELETE FROM lesiones_partes_cuerpo__paciente WHERE id_his = _id_his;

	_arr_3 := STRING_TO_ARRAY(_str_les,',');
	IF (ARRAY_UPPER(_arr_3,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_3,1)) LOOP
			_arr_2 := STRING_TO_ARRAY(replace(replace(_arr_3[i],'(',''),')',''),';');
			INSERT INTO lesiones_partes_cuerpos__pacientes (
				id_tip_mic_pac,
				id_cat_cue_les,
				id_par_cue_cat_cue
			) VALUES (
				_id_tip_mic_pac,
				_arr_2[1],
				_arr_2[2]				
			);
		END LOOP;
	END IF;

	-- insertando los tipos de estudios micologicos pertenecientes a la enfermedad que padece el paciente
	_arr_1 := STRING_TO_ARRAY(_str_tip_est_mic,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP
			INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (
				id_tip_mic_pac,
				id_tip_est_mic					
			) VALUES (
				_id_tip_mic_pac,
				_arr_1[i]
			);
		END LOOP;
	END IF;

	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_insertar_micosis_pacientes(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2348 (class 0 OID 0)
-- Dependencies: 37
-- Name: FUNCTION med_insertar_micosis_pacientes(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_insertar_micosis_pacientes(character varying[]) IS '
NOMBRE: med_insertar_micosis_pacientes
TIPO: Function (store procedure)

PARAMETROS: Recibe 4 Parámetros
	
	1:  Id del historico del paciente.
	2:  Id tipo micosis paciente.
	3:  String de las enfermedades del paciente, separados por ","
	4:  String de las lesiones del paciente.
	5:  Id del doctor.	

DESCRIPCION: 
	Inserta las enfermedades y las lesiones del paciente

RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_insertar_micosis_pacientes(ARRAY[
                ''16'',
                ''1'',               
                ''1,2'',
                ''(2;1)'',
                ''1''
                ''6''              
                ]
            ) AS result 

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 15/08/2011

';


--
-- TOC entry 32 (class 1255 OID 18865)
-- Dependencies: 6 470
-- Name: med_modificar_hitorial_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_modificar_hitorial_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente
	_id_his 		historiales_pacientes.id_his%TYPE;
	_des_his 		historiales_pacientes.des_his%TYPE;
	_des_adi_pac_his	historiales_pacientes.des_adi_pac_his%TYPE;	
	
	-- informacion del doctor
	_id_doc			doctores.id_doc%TYPE;

	_tra_usu		transacciones.cod_tip_tra%TYPE;

	_valorcampos 		VARCHAR := '';
	_reg_ant		RECORD;
	_reg_act		RECORD;
	_reg_usu		RECORD;
	_reg_tra		RECORD;
	
BEGIN
	-- pacientes
	_id_his 		:= _datos[1];
	_des_his 		:= _datos[2];
	_des_adi_pac_his	:= _datos[3];

	-- doctor	
	_id_doc			:= _datos[4];
	_tra_usu		:= _datos[5];

	-- historial del paciente
		
	/*Busco el registro anterior del historial del paciente*/
	SELECT nom_pac,ape_pac,ced_pac,des_his,des_adi_pac_his,fec_his INTO _reg_ant
	FROM historiales_pacientes LEFT JOIN pacientes USING(id_pac) 
	WHERE id_his = _id_his;

	
	UPDATE historiales_pacientes SET 		
		des_his 	= _des_his, 	
		des_adi_pac_his = _des_adi_pac_his				
		WHERE id_his 	= _id_his;

	/*Busco el registro actuales del historial del paciente*/
	SELECT nom_pac,ape_pac,ced_pac,fec_his INTO _reg_act
	FROM historiales_pacientes LEFT JOIN pacientes USING(id_pac) 
	WHERE id_his = _id_his;

	/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
	_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><modificacion_del_historial_paciente>
		 <tabla nombre="historiales_pacientes">';
		_valorcampos := _valorcampos || 
		formato_campo_xml('Nombre Paciente', 		coalesce(_reg_act.nom_pac::text, 'ninguno'), 	coalesce(_reg_ant.nom_pac::text,'ninguno'))||
		formato_campo_xml('Apellido Paciente',  	coalesce(_reg_act.ape_pac::text, 'ninguno'), 	coalesce(_reg_ant.ape_pac::text,'ninguno'))||
		formato_campo_xml('Cédula Paciente', 		coalesce(_reg_act.ced_pac::text, 'ninguno'), 	coalesce(_reg_ant.ced_pac::text,'ninguno'))||
		formato_campo_xml('Descripción de la Historia', coalesce(_des_his::text, 'ninguno'), 		coalesce(_reg_ant.des_his::text,'ninguno'))||
		formato_campo_xml('Descripción Adicional', 	coalesce(_des_adi_pac_his::text, 'ninguno'), 	coalesce(_reg_ant.des_adi_pac_his::text,'ninguno'))||
		formato_campo_xml('Fecha de Historia', 		coalesce(_reg_act.fec_his::text, 'ninguno'), 	coalesce(_reg_ant.fec_his::text,'ninguno'));
		/*ªª Se cierra el tag de la tabla */
		_valorcampos := _valorcampos || '</tabla>';
	_valorcampos := _valorcampos || '</modificacion_del_historial_paciente>';	

		
	/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
	SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

	/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
	SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
	
	INSERT INTO auditoria_transacciones
	(
		fec_aud_tra, 
		id_tip_usu_usu,
		id_tip_tra, 
		data_xml
	)
	VALUES 
	(
		 NOW(), 
		_reg_usu.id_tip_usu_usu, 
		_reg_tra.id_tip_tra, 
		_valorcampos::XML
	);
		
	RETURN 1; -- La función se ejecutó exitosamente	

END;$_$;


ALTER FUNCTION public.med_modificar_hitorial_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2349 (class 0 OID 0)
-- Dependencies: 32
-- Name: FUNCTION med_modificar_hitorial_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_modificar_hitorial_paciente(character varying[]) IS '
NOMBRE: med_modificar_hitorial_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 4 Parámetros

	1:  Id del historial.
	2:  Descripción delhec historico.
	3:  Descripción adicional del paciente.
	4:  Id del doctor que se encuentra logueado en el sistema.
	5:  Código de la transacción
DESCRIPCION: 
	Modifica la información del historico de los pacientes

RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_registrar_hitorial_paciente(ARRAY[ ''7'', ''lkhlkjh'', ''jhgfjgf'', ''6'',''MHP'' ]) AS result

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 26/06/2011


AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 23/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 35 (class 1255 OID 19224)
-- Dependencies: 470 6
-- Name: med_modificar_micosis_pacientes(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_modificar_micosis_pacientes(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;	

	_id_tip_mic_pac tipos_micosis_pacientes.id_tip_mic_pac%TYPE;
	_id_tip_mic		tipos_micosis.id_tip_mic%TYPE;
	_str_enf_pac		TEXT;
	_str_les		TEXT;
	_str_tip_est_mic	TEXT;	

	-- cadena para manipular el array
	_str		TEXT;
		
	_id_doc		doctores.id_doc%TYPE;
	
	_arr_1	INTEGER[];	
	_arr_2	INTEGER[];
	_arr_3	TEXT[];	
	
	
BEGIN

	-- pacientes	
	_id_tip_mic_pac		:= _datos[1];
	_str_enf_pac		:= _datos[2];
	_str_les		:= _datos[3];
	_str_tip_est_mic	:= _datos[4];		
	_id_doc			:= _datos[5];	
		
	-- enfermedades del paciente
	DELETE FROM enfermedades_pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac;

	_arr_1 := STRING_TO_ARRAY(_str_enf_pac,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP
			INSERT INTO enfermedades_pacientes (
				id_tip_mic_pac,
				id_enf_mic					
			) VALUES (
				_id_tip_mic_pac,
				_arr_1[i]
			);
		END LOOP;
	END IF;

	-- tipo de consulta del paciente referidos al historico
	DELETE FROM lesiones_partes_cuerpos__pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac;
	
	_arr_3 := STRING_TO_ARRAY(_str_les,',');
	
	IF (ARRAY_UPPER(_arr_3,1) > 0)THEN
	
		FOR i IN 1..(ARRAY_UPPER(_arr_3,1)) LOOP		
			_arr_2 := STRING_TO_ARRAY(replace(replace(_arr_3[i] ,'(',''),')',''),';');
			
			INSERT INTO lesiones_partes_cuerpos__pacientes (
				id_tip_mic_pac,
				id_cat_cue_les,
				id_par_cue_cat_cue
			) VALUES (
				_id_tip_mic_pac,
				_arr_2[1],
				_arr_2[2]				
			);
		END LOOP;
	END IF;

	-- enfermedades del paciente
	DELETE FROM tipos_micosis_pacientes__tipos_estudios_micologicos WHERE id_tip_mic_pac = _id_tip_mic_pac;

	_arr_1 := STRING_TO_ARRAY(_str_tip_est_mic,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP
			INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (
				id_tip_mic_pac,
				id_tip_est_mic					
			) VALUES (
				_id_tip_mic_pac,
				_arr_1[i]
			);
		END LOOP;
	END IF;

	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_modificar_micosis_pacientes(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2350 (class 0 OID 0)
-- Dependencies: 35
-- Name: FUNCTION med_modificar_micosis_pacientes(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_modificar_micosis_pacientes(character varying[]) IS '
NOMBRE: med_modificar_micosis_pacientes
TIPO: Function (store procedure)

PARAMETROS: Recibe 4 Parámetros
		
	1:  Id tipo micosis paciente.
	2:  String de las enfermedades del paciente, separados por ","
	3:  String de las lesiones del paciente.
	4:  Id del doctor.	

DESCRIPCION: 
	Modifica las enfermedades y las lesiones del paciente

RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_modificar_micosis_pacientes(ARRAY[                
                ''1'',               
                ''1,2'',
                ''(2;1)'',
                ''5'',
                ''6''              
		]
	    ) AS result 

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 15/08/2011

';


--
-- TOC entry 31 (class 1255 OID 18759)
-- Dependencies: 6 470
-- Name: med_modificar_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_modificar_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente
	_id_pac		pacientes.id_pac%TYPE;
	_nom_pac 	pacientes.nom_pac%TYPE;
	_ape_pac 	pacientes.ape_pac%TYPE;
	_ced_pac	pacientes.ced_pac%TYPE;
	_fec_nac_pac 	pacientes.fec_nac_pac%TYPE;
	_nac_pac 	pacientes.nac_pac%TYPE;
	_tel_hab_pac	pacientes.tel_hab_pac%TYPE;
	_tel_cel_pac	pacientes.tel_cel_pac%TYPE;
	_ocu_pac	pacientes.ocu_pac%TYPE;
	_ciu_pac	pacientes.ciu_pac%TYPE;
	_id_pai		pacientes.id_pai%TYPE;
	_id_est		pacientes.id_est%TYPE;
	_id_mun		pacientes.id_mun%TYPE;
	_id_par		pacientes.id_par%TYPE;
	_tra_usu	transacciones.cod_tip_tra%TYPE;
	_str_ant_per	TEXT;
	_arr_ant_per	INTEGER[];
	_valorcampos 	VARCHAR := '';
	_des_ant_per 	VARCHAR := '';
	_des_ant_per_ant VARCHAR := '';	
	
	-- informacion del doctor

	_id_doc		doctores.id_doc%TYPE;

	_reg_pac	RECORD;
	_reg_ant	RECORD;
	_reg_act	RECORD;

	_reg_usu	RECORD;
	_reg_tra	RECORD;
	
BEGIN
	-- pacientes
	_id_pac		:= _datos[1];	
	_nom_pac 	:= _datos[2];
	_ape_pac 	:= _datos[3];
	_ced_pac	:= _datos[4];
	_fec_nac_pac 	:= _datos[5];
	_nac_pac 	:= _datos[6];
	_tel_hab_pac	:= _datos[7];
	_tel_cel_pac	:= _datos[8];
	_ocu_pac	:= _datos[9];
	_ciu_pac	:= _datos[10];
	_id_pai		:= _datos[11];
	_id_est		:= _datos[12];
	_id_mun		:= _datos[13];
	_str_ant_per	:= _datos[14];	
	_id_doc		:= _datos[15];
	_tra_usu	:= _datos[16];

	-- centros de salud pacientes
	
	
	/* validando pacientes */
	IF EXISTS (SELECT 1 FROM pacientes WHERE id_pac = _id_pac::integer) THEN  

		/*Busco el registro anterior del paciente*/
		SELECT 	id_pac,ape_pac,nom_pac,ced_pac,fec_nac_pac,tel_hab_pac,tel_cel_pac,ciu_pac,id_pai,id_est,id_mun, 
			CASE 
				WHEN nac_pac = '1' THEN 'Venezolano' ELSE 'Extranjero' 
			END AS nac_pac,
			CASE 
				WHEN ocu_pac = '1' THEN 'Profesional'
				WHEN ocu_pac = '2' THEN 'Técnico'
				WHEN ocu_pac = '3' THEN 'Obrero'
				WHEN ocu_pac = '4' THEN 'Agricultor'
				WHEN ocu_pac = '5' THEN 'Jardinero'
				WHEN ocu_pac = '6' THEN 'Otro'
			END AS ocu_pac  INTO _reg_pac
		FROM pacientes 
		WHERE id_pac = _id_pac;
		
				
		/*Busco el registro anterior de la descripción del país, estado y municipio*/
		SELECT des_pai, des_est, des_mun INTO _reg_ant
		FROM paises p
			LEFT JOIN estados e ON(p.id_pai = e.id_pai)
			LEFT JOIN municipios m ON(e.id_est = m.id_est)
		WHERE p.id_pai = _reg_pac.id_pai
			AND e.id_est = _reg_pac.id_est
			AND m.id_mun = _reg_pac.id_mun;
			
		/*Modificando pacientes*/
		UPDATE  pacientes SET
			nom_pac 	= _nom_pac,	
			ape_pac 	= _ape_pac, 	
			ced_pac 	= _ced_pac,	
			fec_nac_pac 	= _fec_nac_pac, 	
			nac_pac 	= _nac_pac, 	
			tel_hab_pac 	= _tel_hab_pac,	
			tel_cel_pac 	= _tel_cel_pac,	
			ocu_pac 	= _ocu_pac,	
			ciu_pac 	= _ciu_pac,	
			id_pai 		= _id_pai,		
			id_est 		= _id_est,		
			id_mun 		= _id_mun			

			WHERE id_pac = _id_pac
		;

		/*Busco todos los registros actuales del paciente*/
		SELECT 	p.des_pai, e.des_est, m.des_mun,
			CASE 
				WHEN pa.nac_pac = '1' THEN 'Venezolano' ELSE 'Extranjero' 
			END AS nac_pac,
			CASE 
				WHEN pa.ocu_pac = '1' THEN 'Profesional'
				WHEN pa.ocu_pac = '2' THEN 'Técnico'
				WHEN pa.ocu_pac = '3' THEN 'Obrero'
				WHEN pa.ocu_pac = '4' THEN 'Agricultor'
				WHEN pa.ocu_pac = '5' THEN 'Jardinero'
				WHEN pa.ocu_pac = '6' THEN 'Otro'
			END AS ocu_pac  INTO _reg_act
		FROM pacientes pa
			LEFT JOIN paises p USING(id_pai)
			LEFT JOIN estados e ON(p.id_pai = e.id_pai)
			LEFT JOIN municipios m ON(e.id_est = m.id_est)
		WHERE pa.id_pac = _id_pac
			AND p.id_pai = _id_pai
			AND e.id_est = _id_est
			AND m.id_mun = _id_mun;



		/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
		_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><modificacion_de_pacientes>
				 <tabla nombre="pacientes">';
				_valorcampos := _valorcampos || 
				formato_campo_xml('Nombre',  		coalesce(_nom_pac::text, 'ninguno'), 		coalesce(_reg_pac.nom_pac::text, 'ninguno'))||
				formato_campo_xml('Apellido', 		coalesce(_ape_pac::text, 'ninguno'), 		coalesce(_reg_pac.ape_pac::text, 'ninguno'))||
				formato_campo_xml('Cédula', 		coalesce(_ced_pac::text, 'ninguno'), 		coalesce(_reg_pac.ced_pac::text, 'ninguno'))||  
				formato_campo_xml('Fecha Nacimiento', 	coalesce(_fec_nac_pac::text, 'ninguno'), 	coalesce(_reg_pac.fec_nac_pac::text, 'ninguno'))||  
				formato_campo_xml('Nacionalidad', 	coalesce(_reg_act.nac_pac::text, 'ninguno'), 	coalesce(_reg_pac.nac_pac::text, 'ninguno'))||  
				formato_campo_xml('Teléfono Habitación',coalesce(_tel_hab_pac::text, 'ninguno'), 	coalesce(_reg_pac.tel_hab_pac::text, 'ninguno'))||
				formato_campo_xml('Teléfono Célular', 	coalesce(_tel_cel_pac::text, 'ninguno'), 	coalesce(_reg_pac.tel_cel_pac::text, 'ninguno'))|| 
				formato_campo_xml('Ocupación', 		coalesce(_reg_act.ocu_pac::text, 'ninguno'), 	coalesce(_reg_pac.ocu_pac::text, 'ninguno'))||
				formato_campo_xml('País', 		coalesce(_reg_act.des_pai::text, 'ninguno'), 	coalesce(_reg_ant.des_pai::text, 'ninguno'))||
				formato_campo_xml('Estado', 		coalesce(_reg_act.des_est::text, 'ninguno'), 	coalesce(_reg_ant.des_est::text, 'ninguno'))||
				formato_campo_xml('Municipio', 		coalesce(_reg_act.des_mun::text, 'ninguno'), 	coalesce(_reg_ant.des_mun::text, 'ninguno'))||
				formato_campo_xml('Ciudad', 		coalesce(_ciu_pac::text, 'ninguno'), 		coalesce(_reg_pac.ciu_pac::text, 'ninguno'));  
			/*ªª Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';

			/*Busco el registro anterior del nombre antecedente personal*/
			FOR _reg_ant IN (SELECT nom_ant_per FROM antecedentes_pacientes LEFT JOIN antecedentes_personales USING(id_ant_per) WHERE id_pac = _id_pac) LOOP
				_des_ant_per_ant := _des_ant_per_ant || _reg_ant.nom_ant_per || ' ,';
			END LOOP;
		
			/* Se le quita la última de las comas a la variable */
			IF length(_des_ant_per_ant) > 0 THEN
				_des_ant_per_ant := substr(_des_ant_per_ant, 1, length(_des_ant_per_ant) - 1);
			END IF;
			
			DELETE FROM antecedentes_pacientes WHERE id_pac = _id_pac;
			_arr_ant_per := STRING_TO_ARRAY(_str_ant_per,',');
			IF (ARRAY_UPPER(_arr_ant_per,1) > 0)THEN
				FOR i IN 1..(ARRAY_UPPER(_arr_ant_per,1)) LOOP
					INSERT INTO antecedentes_pacientes (
						id_pac,
						id_ant_per					
					) VALUES (
						_id_pac,
						_arr_ant_per[i]
					);
					SELECT nom_ant_per INTO _reg_act FROM antecedentes_personales WHERE id_ant_per = _arr_ant_per[i];
					_des_ant_per := _des_ant_per || _reg_act.nom_ant_per || ' ,';
				END LOOP;
			END IF;


			/* Se le quita la última de las comas a la variable */
			IF length(_des_ant_per) > 0 THEN
				_des_ant_per := substr(_des_ant_per, 1, length(_des_ant_per) - 1);
			END IF;	
			
			/* Se identifica la tabla en el formato xml */
			_valorcampos := _valorcampos || '<tabla nombre="antecedentes_personales">';
			/* Se completa el tag con el valor del campo */
				_valorcampos := _valorcampos || 
				formato_campo_xml('Antecedentes Personales', coalesce(_des_ant_per::text, 'ninguno'), coalesce(_des_ant_per_ant::text));
			/* Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';
			
		_valorcampos := _valorcampos || '</modificacion_de_pacientes>';	

		
		/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
		SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

		/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
		SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
		
		INSERT INTO auditoria_transacciones
		(
			fec_aud_tra, 
			id_tip_usu_usu,
			id_tip_tra, 
			data_xml
		)
		VALUES 
		(
			 NOW(), 
			_reg_usu.id_tip_usu_usu, 
			_reg_tra.id_tip_tra, 
			_valorcampos::XML
		);
		
		-- La función se ejecutó exitosamente
		RETURN 1;
		
	
	ELSE
		-- Existe un usuario administrativo con el mismo login
		RETURN 0;
	END IF;

END;$_$;


ALTER FUNCTION public.med_modificar_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2351 (class 0 OID 0)
-- Dependencies: 31
-- Name: FUNCTION med_modificar_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_modificar_paciente(character varying[]) IS '
NOMBRE: med_modificar_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 12 Parámetros
	1:  Id del paciente a modificar
	2:  Nombre paciente
	3:  Apellido del paciente
	4:  Cédula del paciente
	5:  Fecha de nacimiento del paciente
	6:  Nacionalidad del paciente
	7:  Teléfono de habitacion del paciente
	8:  Teléfono de celular del paciente
	9:  Ocupacion del paciente
	10:  Ciudad donde se encuentra el paciente
	11: Id del pais donde vive el paciente
	12: Id del estado donde vive el paciente.
	13: Id del municipio donde vive el paciente.
	14: Id de los antecedentes personales
	15: Id del doctor quien realizo la transacción
	16: Código de la transaccion
	

DESCRIPCION: 
	Modifica la información de los pacientes

RETORNO:
	1: La función se ejecutó exitosamente
	0: Existe un usuario administrativo con el mismo login
	 
EJEMPLO DE LLAMADA:
	SELECT med_modificar_paciente(ARRAY[
                ''66'',
                ''pruebalis'', 
                ''pruebalis'', 
                ''1789654232'', 
                ''1987-08-08'',
                ''2'',
                ''02129514777'',
                ''777777777'',
                ''2'',
                ''css'',
                ''1'',
                ''15'',
                ''200'',
                ''2,3,4,5,8'',
                ''32'',
                ''MP''
            ]) AS result;

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 16/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.

';


--
-- TOC entry 36 (class 1255 OID 18907)
-- Dependencies: 470 6
-- Name: med_muestra_clinica_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_muestra_clinica_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente	
	_str_mue_cli		TEXT;	
	_id_doc			doctores.id_doc%TYPE;
	_id_his			historiales_pacientes.id_his%TYPE;
	_tra_usu		transacciones.cod_tip_tra%TYPE;
	
	_nom_mue_cli_ant	VARCHAR;
	_nom_mue_cli_act	VARCHAR;
	_valorcampos 		VARCHAR := '';
	_reg_pac		RECORD;
	_reg_ant		RECORD;
	_reg_act		RECORD;

	_reg_usu		RECORD;
	_reg_tra		RECORD;
		
	_arr			INTEGER[];		
BEGIN
	-- pacientes
	_id_his			:= _datos[1];	
	_str_mue_cli		:= _datos[2];		
	_id_doc			:= _datos[3];	
	_tra_usu		:= _datos[4];



	/*Busco el registro anterior del paciente*/
	SELECT nom_pac,ape_pac,ced_pac, id_his  INTO _reg_pac
	FROM pacientes p 
		LEFT JOIN historiales_pacientes hp USING(id_pac)
	WHERE id_his = _id_his;

	/*Busco el registro anterior del nombre de la muestra clinica del paciente*/
	FOR _reg_ant IN (SELECT nom_mue_cli FROM muestras_pacientes mp LEFT JOIN muestras_clinicas mc ON(mp.id_mue_cli = mc.id_mue_cli) WHERE mp.id_his = _id_his) LOOP
		_nom_mue_cli_ant := _nom_mue_cli_ant || _reg_ant.nom_mue_cli || ' ,';
	END LOOP;

	/* Se le quita la última de las comas a la variable */
	IF length(_nom_mue_cli_ant) > 0 THEN
		_nom_mue_cli_ant := substr(_nom_mue_cli_ant, 1, length(_nom_mue_cli_ant) - 1);
	END IF;
		
	
	DELETE FROM muestras_pacientes WHERE id_his = _id_his;

	_arr := STRING_TO_ARRAY(_str_mue_cli,',');
	IF (ARRAY_UPPER(_arr,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr,1)) LOOP
			INSERT INTO muestras_pacientes (
				id_his,
				id_mue_cli					
			) VALUES (
				_id_his,
				_arr[i]
			);

			SELECT nom_mue_cli INTO _reg_act FROM muestras_pacientes mp LEFT JOIN muestras_clinicas mc ON(mp.id_mue_cli = mc.id_mue_cli) WHERE id_mue_cli = _arr[i];
			_nom_mue_cli_act := _nom_mue_cli_act || _reg_act.nom_mue_cli || ' ,';
		END LOOP;
	END IF;


	/* Se le quita la última de las comas a la variable */
	IF length(_nom_mue_cli_act) > 0 THEN
		_nom_mue_cli_act := substr(_nom_mue_cli_act, 1, length(_nom_mue_cli_act) - 1);
	END IF;	

	/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
	_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><registrar_muestra_clínica_paciente>
			 <tabla nombre="muestras_pacientes">';
			_valorcampos := _valorcampos || 
			formato_campo_xml('Nombre',  		coalesce(_reg_pac.nom_pac::text, 'ninguno'), 	coalesce(_reg_pac.nom_pac::text, 'ninguno'))||
			formato_campo_xml('Apellido', 		coalesce(_reg_pac.ape_pac::text, 'ninguno'), 	coalesce(_reg_pac.ape_pac::text, 'ninguno'))||
			formato_campo_xml('Cédula', 		coalesce(_reg_pac.ced_pac::text, 'ninguno'), 	coalesce(_reg_pac.ced_pac::text, 'ninguno'))||  
			formato_campo_xml('Muestra Clínica',  	coalesce(_nom_mue_cli_act::text, 'ninguno'), 	coalesce(_nom_mue_cli_ant::text, 'ninguno'));
			/* Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';
	_valorcampos := _valorcampos || '</registrar_muestra_clínica_paciente>';	

	
	/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
	SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

	/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
	SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
	
	INSERT INTO auditoria_transacciones
	(
		fec_aud_tra, 
		id_tip_usu_usu,
		id_tip_tra, 
		data_xml
	)
	VALUES 
	(
		 NOW(), 
		_reg_usu.id_tip_usu_usu, 
		_reg_tra.id_tip_tra, 
		_valorcampos::XML
	);

	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_muestra_clinica_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2352 (class 0 OID 0)
-- Dependencies: 36
-- Name: FUNCTION med_muestra_clinica_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_muestra_clinica_paciente(character varying[]) IS '
NOMBRE: med_muestra_clinica_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 3 Parámetros
	1:  Id del historico del paciente
	2:  Id de Muestras clínicas del paciente
	3:  Id del doctor quien realizo la transacción
	4:  Código de la transaccion	

DESCRIPCION: 
	Modifica la información de las muestras clínicas del paciente
RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_muestra_clinica_paciente(ARRAY[
                ''16'',
                ''7'',
                ''6,7'',
                ''3'',
                ''4'',
                ''1'',
                ''6''                
                ]
            ) AS result 

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 03/08/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 25/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 30 (class 1255 OID 18863)
-- Dependencies: 6 470
-- Name: med_registrar_hitorial_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_registrar_hitorial_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente
	_id_pac 		pacientes.id_pac%TYPE;
	_des_his 		historiales_pacientes.des_his%TYPE;
	_des_adi_pac_his	historiales_pacientes.des_adi_pac_his%TYPE;
	_id_his			historiales_pacientes.id_his%TYPE;
	
	-- informacion del doctor
	_id_doc			doctores.id_doc%TYPE;
	_tra_usu		transacciones.cod_tip_tra%TYPE;

	_valorcampos 		VARCHAR := '';
	_reg_act		RECORD;
	_reg_usu		RECORD;
	_reg_tra		RECORD;
	
BEGIN
	-- pacientes
	_id_pac 		:= _datos[1];
	_des_his 		:= _datos[2];
	_des_adi_pac_his	:= _datos[3];

	-- doctor	
	_id_doc			:= _datos[4];
	_tra_usu		:= _datos[5];

	-- historial del paciente
	

	/*insertando pacientes*/
	INSERT INTO historiales_pacientes
	(
		id_pac,	
		des_his, 	
		des_adi_pac_his,		
		id_doc		
	)
	VALUES 
	(
		_id_pac,	
		_des_his, 	
		_des_adi_pac_his,		
		_id_doc
	);	

	_id_his:= CURRVAL('historiales_pacientes_id_his_seq');	

	/*Busco el registro actual del historial del paciente*/
	SELECT nom_pac,ape_pac,ced_pac,des_his,des_adi_pac_his,fec_his INTO _reg_act
	FROM historiales_pacientes LEFT JOIN pacientes USING(id_pac) 
	WHERE id_his = _id_his;
	
	/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
	_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><registro_del_historial_paciente>
		 <tabla nombre="historiales_pacientes">';
		_valorcampos := _valorcampos || 
		formato_campo_xml('Nombre Paciente', 		coalesce(_reg_act.nom_pac::text, 'ninguno'), 	'ninguno')||
		formato_campo_xml('Apellido Paciente',  	coalesce(_reg_act.ape_pac::text, 'ninguno'), 	'ninguno')||
		formato_campo_xml('Cédula Paciente', 		coalesce(_reg_act.ced_pac::text, 'ninguno'), 	'ninguno')||
		formato_campo_xml('Descripción de la Historia', coalesce(_des_his::text, 'ninguno'), 		'ninguno')||  
		formato_campo_xml('Descripción Adicional', 	coalesce(_des_adi_pac_his::text, 'ninguno'), 	'ninguno')||  
		formato_campo_xml('Fecha de Historia', 		coalesce(_reg_act.fec_his::text, 'ninguno'), 	'ninguno');  
		/*ªª Se cierra el tag de la tabla */
		_valorcampos := _valorcampos || '</tabla>';
	

		INSERT INTO tiempo_evoluciones(
			id_his
		) VALUES (
			_id_his
		);

		SELECT * INTO _reg_act FROM tiempo_evoluciones;


	/* Se identifica la tabla en el formato xml */
		_valorcampos := _valorcampos || '<tabla nombre="tiempo_evoluciones">';
		/* Se completa el tag con el valor del campo */
			_valorcampos := _valorcampos || 
			formato_campo_xml('Tiempo de Evolución', coalesce(_reg_act.tie_evo::text, 'ninguno'), 'ninguno');
		/* Se cierra el tag de la tabla */
		_valorcampos := _valorcampos || '</tabla>';
		
	_valorcampos := _valorcampos || '</registro_del_historial_paciente>';	

		
		/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
		SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

		/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
		SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
		
		INSERT INTO auditoria_transacciones
		(
			fec_aud_tra, 
			id_tip_usu_usu,
			id_tip_tra, 
			data_xml
		)
		VALUES 
		(
			 NOW(), 
			_reg_usu.id_tip_usu_usu, 
			_reg_tra.id_tip_tra, 
			_valorcampos::XML
		);
		
			
	-- La función se ejecutó exitosamente
	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_registrar_hitorial_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2353 (class 0 OID 0)
-- Dependencies: 30
-- Name: FUNCTION med_registrar_hitorial_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_registrar_hitorial_paciente(character varying[]) IS '
NOMBRE: med_registrar_hitorial_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 4 Parámetros

	1:  Id del paciente.
	2:  Descripción delhec historico.
	3:  Descripción adicional del paciente.
	4:  Id del doctor que se encuentra logueado en el sistema.
	5:  Código de la transacción
DESCRIPCION: 
	Almacena la información del historico de los pacientes

RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_registrar_hitorial_paciente(ARRAY[ ''7'', ''lkhlkjh'', ''jhgfjgf'', ''6'' ]) AS result

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 26/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 17/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 20 (class 1255 OID 18904)
-- Dependencies: 470 6
-- Name: med_registrar_informacion_adicional(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_registrar_informacion_adicional(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente	
	_str_cen_sal	TEXT;
	_str_tip_con	TEXT;
	_str_con_ani	TEXT;
	_str_tra_pre	TEXT;
	_tie_evo	tiempo_evoluciones.tie_evo%TYPE;
	_id_doc		doctores.id_doc%TYPE;
	_tra_usu	transacciones.cod_tip_tra%TYPE;
	_id_his		historiales_pacientes.id_his%TYPE;
		
	_arr		INTEGER[];
	_valorcampos 	VARCHAR := '';
	_reg_ant	RECORD;
	_reg_act	RECORD;
	_reg_usu	RECORD;
	_reg_tra	RECORD;
		
	/*Centro de Salud*/
	_anterior	VARCHAR:= '';
	_actual		VARCHAR:= '';
	
	
BEGIN
	-- pacientes
	_id_his			:= _datos[1];	
	_str_cen_sal		:= _datos[2];	
	_str_tip_con		:= _datos[3];	
	_str_con_ani		:= _datos[4];	
	_str_tra_pre		:= _datos[5];	
	_tie_evo		:= _datos[6];	
	_id_doc			:= _datos[7];	
	_tra_usu		:= _datos[8];


	/****************************************CENTRO DE SALUD********************************************/
	
	/*Busco el registro anterior del Centro de Salud del paciante*/
	FOR _reg_ant IN (SELECT nom_cen_sal FROM centro_salud_pacientes	 LEFT JOIN centro_saluds USING(id_cen_sal) WHERE id_his = _id_his) LOOP
		_anterior := _anterior || _reg_ant.nom_cen_sal || ' ,';
	END LOOP;

	
	/* Se le quita la última de las comas a la variable */
	IF length(_anterior) > 0 THEN
		_anterior := substr(_anterior, 1, length(_anterior) - 1);
	END IF;

	-- centro de salud del paciente referidos al historico
	DELETE FROM centro_salud_pacientes WHERE id_his = _id_his;

	_arr := STRING_TO_ARRAY(_str_cen_sal,',');
	IF (ARRAY_UPPER(_arr,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr,1)) LOOP
			INSERT INTO centro_salud_pacientes (
				id_his,
				id_cen_sal					
			) VALUES (
				_id_his,
				_arr[i]
			);
			/*Busco el registro actual del Centro de Salud del paciante*/
			SELECT nom_cen_sal INTO _reg_act FROM centro_salud_pacientes LEFT JOIN centro_saluds USING(id_cen_sal) WHERE id_cen_sal = _arr[i];
			_actual := _actual || _reg_act.nom_cen_sal || ' ,';
		END LOOP;
	END IF;

	/* Se le quita la última de las comas a la variable */
	IF length(_actual) > 0 THEN
		_actual := substr(_actual, 1, length(_actual) - 1);
	END IF;	


	/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
	_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><Información_adicional>
			 <tabla nombre="centro_salud_pacientes">';
			_valorcampos := _valorcampos || 
			formato_campo_xml('Centros de Salud',  	coalesce(_actual::text, 'ninguno'), 	coalesce(_anterior::text, 'ninguno'));  
		/*ªª Se cierra el tag de la tabla */
		_valorcampos := _valorcampos || '</tabla>';


	/****************************************TIPOS DE CONSULTAS********************************************/


	/*Busco el registro anterior del tipo de consulta del paciante*/
	FOR _reg_ant IN (SELECT nom_tip_con FROM tipos_consultas_pacientes LEFT JOIN tipos_consultas USING(id_tip_con) WHERE id_his = _id_his) LOOP
		_anterior := _anterior || _reg_ant.nom_tip_con || ' ,';
	END LOOP;

	/* Se le quita la última de las comas a la variable */
	IF length(_anterior) > 0 THEN
		_anterior := substr(_anterior, 1, length(_anterior) - 1);
	END IF;
	

	-- tipo de consulta del paciente referidos al historico
	DELETE FROM tipos_consultas_pacientes WHERE id_his = _id_his;

	_arr := STRING_TO_ARRAY(_str_tip_con,',');
	IF (ARRAY_UPPER(_arr,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr,1)) LOOP
			INSERT INTO tipos_consultas_pacientes (
				id_his,
				id_tip_con					
			) VALUES (
				_id_his,
				_arr[i]
			);
			/*Busco el registro actual del tipo de consulta del paciante*/
			SELECT nom_tip_con INTO _reg_act FROM tipos_consultas_pacientes LEFT JOIN tipos_consultas USING(id_tip_con) WHERE id_tip_con = _arr[i];
			_actual := _actual || _reg_act.nom_tip_con || ' ,';
		END LOOP;
	END IF;

	/* Se le quita la última de las comas a la variable */
	IF length(_actual) > 0 THEN
		_actual := substr(_actual, 1, length(_actual) - 1);
	END IF;	

	/* Se identifica la tabla en el formato xml */
	_valorcampos := _valorcampos || '<tabla nombre="tipos_consultas_pacientes">';
	/* Se completa el tag con el valor del campo */
		_valorcampos := _valorcampos || 
		formato_campo_xml('Tipos de Consultas', coalesce(_actual::text, 'ninguno'), coalesce(_anterior::text));
	/* Se cierra el tag de la tabla */
	_valorcampos := _valorcampos || '</tabla>';


	
	/****************************************CONTACTOS CON ANIMALES********************************************/

	/*Busco el registro anterior del contacto con animales del paciante*/
	FOR _reg_ant IN (SELECT nom_ani FROM contactos_animales LEFT JOIN animales USING(id_ani) WHERE id_his = _id_his) LOOP
		_anterior := _anterior || _reg_ant.nom_ani || ' ,';
	END LOOP;

	/* Se le quita la última de las comas a la variable */
	IF length(_anterior) > 0 THEN
		_anterior := substr(_anterior, 1, length(_anterior) - 1);
	END IF;

	
	-- contacto animales del paciente referidos al historico
	DELETE FROM contactos_animales WHERE id_his = _id_his;

	_arr := STRING_TO_ARRAY(_str_con_ani,',');
	IF (ARRAY_UPPER(_arr,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr,1)) LOOP
			INSERT INTO contactos_animales (
				id_his,
				id_ani					
			) VALUES (
				_id_his,
				_arr[i]
			);
			/*Busco el registro actual del contacto con animales del paciante*/
			SELECT nom_ani INTO _reg_act FROM contactos_animales LEFT JOIN animales USING(id_ani) WHERE id_ani = _arr[i];
			_actual := _actual || _reg_act.nom_ani || ' ,';
		END LOOP;
	END IF;

	/* Se le quita la última de las comas a la variable */
	IF length(_actual) > 0 THEN
		_actual := substr(_actual, 1, length(_actual) - 1);
	END IF;	

	/* Se identifica la tabla en el formato xml */
	_valorcampos := _valorcampos || '<tabla nombre="contactos_animales">';
	/* Se completa el tag con el valor del campo */
		_valorcampos := _valorcampos || 
		formato_campo_xml('Animales', coalesce(_actual::text, 'ninguno'), coalesce(_anterior::text));
	/* Se cierra el tag de la tabla */
	_valorcampos := _valorcampos || '</tabla>';

	

	/****************************************TRATAMIENTOS********************************************/

	/*Busco el registro anterior del tratamiento del paciante*/
	FOR _reg_ant IN (SELECT nom_tra FROM tratamientos_pacientes LEFT JOIN tratamientos USING(id_tra) WHERE id_his = _id_his) LOOP
		_anterior := _anterior || _reg_ant.nom_tra || ' ,';
	END LOOP;

	/* Se le quita la última de las comas a la variable */
	IF length(_anterior) > 0 THEN
		_anterior := substr(_anterior, 1, length(_anterior) - 1);
	END IF;

	
	-- Tratamientos del paciente referidos al historico
	DELETE FROM tratamientos_pacientes WHERE id_his = _id_his;

	_arr := STRING_TO_ARRAY(_str_tra_pre,',');
	IF (ARRAY_UPPER(_arr,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr,1)) LOOP
			INSERT INTO tratamientos_pacientes (
				id_his,
				id_tra					
			) VALUES (
				_id_his,
				_arr[i]
			);
			/*Busco el registro actual del tratamiento del paciante*/
			SELECT nom_tra INTO _reg_act FROM tratamientos_pacientes LEFT JOIN tratamientos USING(id_tra) WHERE id_tra = _arr[i];
			_actual := _actual || _reg_act.nom_tra || ' ,';
		END LOOP;
	END IF;

	/* Se le quita la última de las comas a la variable */
	IF length(_actual) > 0 THEN
		_actual := substr(_actual, 1, length(_actual) - 1);
	END IF;	

	/* Se identifica la tabla en el formato xml */
	_valorcampos := _valorcampos || '<tabla nombre="tratamientos_pacientes">';
	/* Se completa el tag con el valor del campo */
		_valorcampos := _valorcampos || 
		formato_campo_xml('Tratamientos', coalesce(_actual::text, 'ninguno'), coalesce(_anterior::text));
	/* Se cierra el tag de la tabla */
	_valorcampos := _valorcampos || '</tabla>';
	
	

	/****************************************TIEMPO DE EVOLUCIÓN********************************************/

	/*Busco el registro anterior del Tiempo de Evolución del paciante*/
	SELECT tie_evo INTO _reg_ant FROM tiempo_evoluciones WHERE id_his = _id_his;
	
	/* insertando tiempo de evoluciones */	
	IF NOT EXISTS (SELECT 1 FROM tiempo_evoluciones WHERE id_his = _id_his::integer) THEN  
		INSERT INTO tiempo_evoluciones(
			id_his,
			tie_evo
		) VALUES (
			_id_his,
			_tie_evo
		);
	ELSE
		UPDATE tiempo_evoluciones SET 
			tie_evo = _tie_evo
		WHERE id_his = _id_his ;
	END IF;

	/*Busco el registro anterior del Tiempo de Evolución del paciante*/
	SELECT tie_evo INTO _reg_act FROM tiempo_evoluciones WHERE id_his = _id_his;

	/* Se identifica la tabla en el formato xml */
	_valorcampos := _valorcampos || '<tabla nombre="tiempo_evoluciones">';
	/* Se completa el tag con el valor del campo */
		_valorcampos := _valorcampos || 
		formato_campo_xml('Evolución', coalesce(_reg_act.tie_evo::text, 'ninguno'), coalesce(_reg_ant.tie_evo::text));
	/* Se cierra el tag de la tabla */
	_valorcampos := _valorcampos || '</tabla>';

	_valorcampos := _valorcampos || '</Información_adicional>';


	--raise notice '_valorcampos5-->%',_valorcampos;
	
	/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
	SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

	/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
	SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
	
	INSERT INTO auditoria_transacciones
	(
		fec_aud_tra, 
		id_tip_usu_usu,
		id_tip_tra, 
		data_xml
	)
	VALUES 
	(
		 NOW(), 
		_reg_usu.id_tip_usu_usu, 
		_reg_tra.id_tip_tra, 
		_valorcampos::XML
	);	
	
	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_registrar_informacion_adicional(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2354 (class 0 OID 0)
-- Dependencies: 20
-- Name: FUNCTION med_registrar_informacion_adicional(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_registrar_informacion_adicional(character varying[]) IS '
NOMBRE: med_registrar_informacion_adicional
TIPO: Function (store procedure)

PARAMETROS: Recibe 7 Parámetros
	1:  Id del historico del paciente
	2:  Centro de salud del pacient
	3:  Tipo de consulta
	4:  Contacto con animales
	5:  Tratamientos previos
	6:  Tiempo de evolución
	7:  Id del usuario logueado, en este caso el doctor
	8: Código de la transaccion		

DESCRIPCION: 
	Modifica la información adicional de los pacientes

RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_registrar_informacion_adicional(ARRAY[
                ''16'',
                ''7'',
                ''6,7'',
                ''3'',
                ''4'',
                ''1'',
                ''6''                
                ]
            ) AS result 

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 16/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.

';


--
-- TOC entry 33 (class 1255 OID 18645)
-- Dependencies: 470 6
-- Name: med_registrar_paciente(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_registrar_paciente(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente
	_nom_pac 	pacientes.nom_pac%TYPE;
	_ape_pac 	pacientes.ape_pac%TYPE;
	_ced_pac	pacientes.ced_pac%TYPE;
	_fec_nac_pac 	pacientes.fec_nac_pac%TYPE;
	_nac_pac 	pacientes.nac_pac%TYPE;
	_tel_hab_pac	pacientes.tel_hab_pac%TYPE;
	_tel_cel_pac	pacientes.tel_cel_pac%TYPE;
	_ocu_pac	pacientes.ocu_pac%TYPE;
	_ciu_pac	pacientes.ciu_pac%TYPE;
	_id_pai		pacientes.id_pai%TYPE;
	_id_est		pacientes.id_est%TYPE;
	_id_mun		pacientes.id_mun%TYPE;
	_id_par		pacientes.id_par%TYPE;	
	_tra_usu	transacciones.cod_tip_tra%TYPE;
	_str_ant_per	TEXT;
	_arr_ant_per	INTEGER[];
	_valorcampos 	VARCHAR := '';
	_des_ant_per 	VARCHAR := '';
	
	_info		RECORD;
	_reg_pac	RECORD;
	_reg_act	RECORD;
	_reg_usu	RECORD;
	_reg_tra	RECORD;
	
	

	-- informacion del doctor

	_id_doc		doctores.id_doc%TYPE;
	
BEGIN
	-- pacientes
	_nom_pac 	:= _datos[1];
	_ape_pac 	:= _datos[2];
	_ced_pac	:= _datos[3];
	_fec_nac_pac 	:= _datos[4];
	_nac_pac 	:= _datos[5];
	_tel_hab_pac	:= _datos[6];
	_tel_cel_pac	:= _datos[7];
	_ocu_pac	:= _datos[8];
	_ciu_pac	:= _datos[9];
	_id_pai		:= _datos[10];
	_id_est		:= _datos[11];
	_id_mun		:= _datos[12];
	_str_ant_per	:= _datos[13];
	_id_doc		:= _datos[14];
	_tra_usu	:= _datos[15];

	-- centros de salud pacientes
	

	/* validando pacientes */
	IF NOT EXISTS (SELECT 1 FROM pacientes WHERE ced_pac = _ced_pac) THEN     		
		
		/*insertando pacientes*/
		INSERT INTO pacientes
		(
			nom_pac,	
			ape_pac, 	
			ced_pac,	
			fec_nac_pac, 	
			nac_pac, 	
			tel_hab_pac,	
			tel_cel_pac,	
			ocu_pac,	
			ciu_pac,	
			id_pai,		
			id_est,		
			id_mun,
			num_pac,
			id_doc		
		)
		VALUES 
		(
			_nom_pac, 	
			_ape_pac, 	
			_ced_pac,	
			_fec_nac_pac, 	
			_nac_pac, 	
			_tel_hab_pac,	
			_tel_cel_pac,	
			_ocu_pac,	
			_ciu_pac,	
			_id_pai,		
			_id_est,		
			_id_mun,
			((SELECT COUNT(id_pac) FROM pacientes )::INTEGER)+1,
			_id_doc
		);

		/*Busco el registro anterior del paciente*/
		SELECT 	p.des_pai, e.des_est, m.des_mun,
			CASE 
				WHEN pa.nac_pac = '1' THEN 'Venezolano' ELSE 'Extranjero' 
			END AS nac_pac,
			CASE 
				WHEN pa.ocu_pac = '1' THEN 'Profesional'
				WHEN pa.ocu_pac = '2' THEN 'Técnico'
				WHEN pa.ocu_pac = '3' THEN 'Obrero'
				WHEN pa.ocu_pac = '4' THEN 'Agricultor'
				WHEN pa.ocu_pac = '5' THEN 'Jardinero'
				WHEN pa.ocu_pac = '6' THEN 'Otro'
			END AS ocu_pac  INTO _reg_pac
		FROM pacientes pa
			LEFT JOIN paises p USING(id_pai)
			LEFT JOIN estados e ON(p.id_pai = e.id_pai)
			LEFT JOIN municipios m ON(e.id_est = m.id_est)
		WHERE pa.id_pac = CURRVAL('pacientes_id_pac_seq')
			AND p.id_pai = _id_pai
			AND e.id_est = _id_est
			AND m.id_mun = _id_mun;


		/* Se coloca el encabezado para los valores de los campos, así como el tag raíz y el inicio del tag tabla */
		_valorcampos := '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><registro_de_pacientes>
				 <tabla nombre="pacientes">';
				_valorcampos := _valorcampos || 
				formato_campo_xml('ID', 		coalesce(_id_doc::text, 'ninguno'), 		'ninguno')||
				formato_campo_xml('Nombre',  		coalesce(_nom_pac::text, 'ninguno'), 		'ninguno')||
				formato_campo_xml('Apellido', 		coalesce(_ape_pac::text, 'ninguno'), 		'ninguno')||
				formato_campo_xml('Cédula', 		coalesce(_ced_pac::text, 'ninguno'), 		'ninguno')||  
				formato_campo_xml('Fecha Nacimiento', 	coalesce(_fec_nac_pac::text, 'ninguno'), 	'ninguno')||  
				formato_campo_xml('Nacionalidad', 	coalesce(_reg_pac.nac_pac::text, 'ninguno'), 	'ninguno')||  
				formato_campo_xml('Teléfono Habitación',coalesce(_tel_hab_pac::text, 'ninguno'), 	'ninguno')||
				formato_campo_xml('Teléfono Célular', 	coalesce(_tel_cel_pac::text, 'ninguno'), 	'ninguno')|| 
				formato_campo_xml('Ocupación', 		coalesce(_reg_pac.ocu_pac::text, 'ninguno'), 	'ninguno')||
				formato_campo_xml('País', 		coalesce(_reg_pac.des_pai::text, 'ninguno'), 	'ninguno')||
				formato_campo_xml('Estado', 		coalesce(_reg_pac.des_est::text, 'ninguno'), 	'ninguno')||
				formato_campo_xml('Municipio', 		coalesce(_reg_pac.des_mun::text, 'ninguno'), 	'ninguno')||
				formato_campo_xml('Ciudad', 		coalesce(_ciu_pac::text, 'ninguno'), 		'ninguno');  
			/*ªª Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';
		

		/* Antecedentes personales*/
		_arr_ant_per := STRING_TO_ARRAY(_str_ant_per,',');
		IF (ARRAY_UPPER(_arr_ant_per,1) > 0)THEN
			FOR i IN 1..(ARRAY_UPPER(_arr_ant_per,1)) LOOP
				INSERT INTO antecedentes_pacientes(
					id_pac,
					id_ant_per
				)
				VALUES
				(
					(CURRVAL('pacientes_id_pac_seq')),
					_arr_ant_per[i]
				);

				SELECT nom_ant_per INTO _info FROM antecedentes_personales WHERE id_ant_per = _arr_ant_per[i];
				_des_ant_per := _des_ant_per || _info.nom_ant_per || ' ,';
			END LOOP;
		END IF;	
		
		/* Se le quita la última de las comas a la variable */
		IF length(_des_ant_per) > 0 THEN
			_des_ant_per := substr(_des_ant_per, 1, length(_des_ant_per) - 1);
		END IF;	
			
			/* Se identifica la tabla en el formato xml */
			_valorcampos := _valorcampos || '<tabla nombre="antecedentes_personales">';
			/* Se completa el tag con el valor del campo */
				_valorcampos := _valorcampos || 
				formato_campo_xml('Antecedentes Personales', coalesce(_des_ant_per::text, 'ninguno'), 'ninguno');
			/* Se cierra el tag de la tabla */
			_valorcampos := _valorcampos || '</tabla>';
			
		_valorcampos := _valorcampos || '</registro_de_pacientes>';	

		
		/*Obtengo el Id del tipo de usuario deacuerdo al usuario logueado*/
		SELECT id_tip_usu_usu INTO _reg_usu FROM tipos_usuarios__usuarios WHERE id_doc = _id_doc;

		/*Obtengo el Id del tipo de transaccion deacuerdo a la transaccion del usuario*/
		SELECT id_tip_tra INTO _reg_tra FROM transacciones WHERE cod_tip_tra = _tra_usu;
		
		INSERT INTO auditoria_transacciones
		(
			fec_aud_tra, 
			id_tip_usu_usu,
			id_tip_tra, 
			data_xml
		)
		VALUES 
		(
			 NOW(), 
			_reg_usu.id_tip_usu_usu, 
			_reg_tra.id_tip_tra, 
			_valorcampos::XML
		);
		
		-- La función se ejecutó exitosamente
		RETURN 1;
	ELSE
		-- Existe un usuario administrativo con el mismo login
		RETURN 0;
	END IF;

END;$_$;


ALTER FUNCTION public.med_registrar_paciente(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2355 (class 0 OID 0)
-- Dependencies: 33
-- Name: FUNCTION med_registrar_paciente(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_registrar_paciente(character varying[]) IS '
NOMBRE: med_registrar_paciente
TIPO: Function (store procedure)

PARAMETROS: Recibe 12 Parámetros
	1:  Nombre paciente
	2:  Apellido del paciente
	3:  Cédula del paciente
	4:  Fecha de nacimiento del paciente
	5:  Nacionalidad del paciente
	6:  Teléfono de habitacion del paciente
	7:  Teléfono de celular del paciente
	8:  Ocupacion del paciente
	9:  Ciudad donde se encuentra el paciente
	10: Id del pais donde vive el paciente
	11: Id del estado donde vive el paciente.
	12: Id del municipio donde vive el paciente.
	13: Id de los antecedentes personales
	14: Id del doctor quien realizo la transacción
	15: Código de la transaccion
	

DESCRIPCION: 
	Almacena la información de los pacientes

RETORNO:
	1: La función se ejecutó exitosamente
	0: Existe un usuario administrativo con el mismo login
	 
EJEMPLO DE LLAMADA:
	SELECT med_registrar_paciente(ARRAY[
                ''prueba'', 
                ''prueba'', 
                ''1789654233'',     
                ''1988-08-08'',
                ''1'',
                ''02129514789'',
                ''04269150755'',
                ''1'',
                ''guarenas'',
                ''1'',
                ''14'',
                ''193'',
                ''2,3,4,8'',
                ''32'',
                ''RP''
            ]) AS result

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 16/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 28 (class 1255 OID 18521)
-- Dependencies: 470 6
-- Name: reg_transacciones(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION reg_transacciones(character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS 	FOR $1;

	_id_tip_usu_usu		auditoria_transacciones.id_tip_usu_usu%TYPE;
	_id_tip_tra		auditoria_transacciones.id_tip_tra%TYPE;	
	_xml			auditoria_transacciones.data_xml%TYPE;	
	
BEGIN
	_id_tip_usu_usu := _datos[1];
	_id_tip_tra 	:= _datos[2];
	_xml 		:= _datos[3]::XML;

	_xml := '<?xml version="1.0" encoding="UTF-8" ?>' || _xml;

	INSERT INTO auditoria_transacciones(
		fec_aud_tra,
		id_tip_usu_usu,
		id_tip_tra,
		data_xml
	) VALUES (
		now(),
		_id_tip_usu_usu,
		_id_tip_tra,
		_xml		
	);

END;
$_$;


ALTER FUNCTION public.reg_transacciones(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2356 (class 0 OID 0)
-- Dependencies: 28
-- Name: FUNCTION reg_transacciones(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION reg_transacciones(character varying[]) IS '
NOMBRE: reg_transacciones
TIPO: Function (store procedure)

PARAMETROS: Recibe 7 Parámetros
	1:  Id del tipo de usuarios usuarios (id_tip_usu_usu)
	2:  Id tip de transacciones de la tabla transacciones
	3:  XML de las tablas a modificar	

DESCRIPCION: 
	Almacena la información de las transacciones de las tablas y los atributos, todas estas transacciones son originadas por los usuarios

RETORNO:
	void
	 
EJEMPLO DE LLAMADA:
	SELECT reg_transacciones(ARRAY[''1'',''1'',''<?xml version="1.0" encoding="UTF-8" ?>'']);

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 05/06/2011

';


--
-- TOC entry 34 (class 1255 OID 19226)
-- Dependencies: 363 470 6
-- Name: validar_usuarios(text, text, text); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION validar_usuarios(_log_usu text, _pas_usu text, _tip_usu text) RETURNS SETOF t_validar_usuarios
    LANGUAGE plpgsql
    AS $_$

DECLARE
	--datos ALIAS FOR $1;
			
	_id_udu_adm		usuarios_administrativos.id_usu_adm%TYPE;
	_nom_usu_adm		usuarios_administrativos.nom_usu_adm%TYPE;
	_ape_usu_adm		usuarios_administrativos.ape_usu_adm%TYPE;
	_pas_usu_adm		usuarios_administrativos.pas_usu_adm%TYPE;
	_log_usu_adm		usuarios_administrativos.log_usu_adm%TYPE;
	_tel_usu_adm		usuarios_administrativos.tel_usu_adm%TYPE;
	_id_tip_usu		tipos_usuarios.id_tip_usu%TYPE;
	_cod_tip_usu		tipos_usuarios.cod_tip_usu%TYPE;
	_t_val_usu		t_validar_usuarios%ROWTYPE;
	_vr_usu		RECORD;
BEGIN


	CASE _tip_usu

		WHEN 'adm' THEN

			IF EXISTS( SELECT 1 FROM usuarios_administrativos WHERE log_usu_adm = _log_usu) THEN
				
				SELECT ua.id_usu_adm, ua.nom_usu_adm, ua.ape_usu_adm, ua.log_usu_adm, ua.tel_usu_adm, tu.id_tip_usu, tu.cod_tip_usu, tu.des_tip_usu, tuu.id_tip_usu_usu INTO _vr_usu  FROM 
				usuarios_administrativos ua
				LEFT JOIN tipos_usuarios__usuarios tuu ON (ua.id_usu_adm = tuu.id_usu_adm)
				LEFT JOIN tipos_usuarios tu ON (tuu.id_tip_usu = tu.id_tip_usu)
				WHERE ua.log_usu_adm = _log_usu
				AND ua.pas_usu_adm = md5(_pas_usu)
				AND tu.cod_tip_usu = _tip_usu;
				
				_t_val_usu.str_trans := ARRAY_TO_STRING (
					ARRAY	(
							SELECT t.cod_tip_tra 
							FROM transacciones_usuarios tu 
							LEFT JOIN transacciones t ON(tu.id_tip_tra = t.id_tip_tra)
							LEFT JOIN tipos_usuarios__usuarios ttu ON(ttu.id_tip_usu_usu = tu.id_tip_usu_usu)
							WHERE ttu.id_tip_usu_usu = _vr_usu.id_tip_usu_usu
					)
				,',');

				_t_val_usu.id_usu 		:=	_vr_usu.id_usu_adm;
				_t_val_usu.nom_usu		:=	_vr_usu.nom_usu_adm;
				_t_val_usu.ape_usu 		:=	_vr_usu.ape_usu_adm;
				_t_val_usu.pas_usu 		:=	'no colocado';
				_t_val_usu.log_usu 		:=	_vr_usu.log_usu_adm;
				_t_val_usu.tel_usu 		:=	_vr_usu.tel_usu_adm;
				_t_val_usu.id_tip_usu 		:=	_vr_usu.id_tip_usu;
				_t_val_usu.id_tip_usu_usu 	:=	_vr_usu.id_tip_usu_usu;				
				_t_val_usu.cod_tip_usu 		:=	_vr_usu.cod_tip_usu;				
				_t_val_usu.des_tip_usu 		:=	_vr_usu.des_tip_usu;
				
			END IF;
			
		WHEN 'med' THEN		
			IF EXISTS( SELECT 1 FROM doctores WHERE log_doc = _log_usu) THEN				
				SELECT d.id_doc, d.nom_doc, d.ape_doc, d.log_doc, d.tel_doc, tu.id_tip_usu, tu.cod_tip_usu, tu.des_tip_usu, tuu.id_tip_usu_usu INTO _vr_usu  FROM 
				doctores d
				LEFT JOIN tipos_usuarios__usuarios tuu ON (d.id_doc = tuu.id_doc)
				LEFT JOIN tipos_usuarios tu ON (tuu.id_tip_usu = tu.id_tip_usu)
				WHERE d.log_doc = _log_usu
				AND d.pas_doc = md5(_pas_usu)
				AND tu.cod_tip_usu = _tip_usu;
				
				_t_val_usu.str_trans := ARRAY_TO_STRING (
					ARRAY	(
							SELECT t.cod_tip_tra 
							FROM transacciones_usuarios tu 
							LEFT JOIN transacciones t ON(tu.id_tip_tra = t.id_tip_tra)
							LEFT JOIN tipos_usuarios__usuarios ttu ON(ttu.id_tip_usu_usu = tu.id_tip_usu_usu)
							WHERE ttu.id_tip_usu_usu = _vr_usu.id_tip_usu_usu
					)
				,',');

				_t_val_usu.id_usu 		:=	_vr_usu.id_doc;
				_t_val_usu.nom_usu		:=	_vr_usu.nom_doc;
				_t_val_usu.ape_usu 		:=	_vr_usu.ape_doc;
				_t_val_usu.pas_usu 		:=	'no colocado';
				_t_val_usu.log_usu 		:=	_vr_usu.log_doc;
				_t_val_usu.tel_usu 		:=	_vr_usu.tel_doc;
				_t_val_usu.id_tip_usu 		:=	_vr_usu.id_tip_usu;
				_t_val_usu.id_tip_usu_usu 	:=	_vr_usu.id_tip_usu_usu;				
				_t_val_usu.cod_tip_usu 		:=	_vr_usu.cod_tip_usu;				
				_t_val_usu.des_tip_usu 		:=	_vr_usu.des_tip_usu;
				
			END IF;
	END CASE;
	
	RETURN NEXT _t_val_usu;
	
END;
$_$;


ALTER FUNCTION public.validar_usuarios(_log_usu text, _pas_usu text, _tip_usu text) OWNER TO desarrollo_g;

--
-- TOC entry 2357 (class 0 OID 0)
-- Dependencies: 34
-- Name: FUNCTION validar_usuarios(_log_usu text, _pas_usu text, _tip_usu text); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION validar_usuarios(_log_usu text, _pas_usu text, _tip_usu text) IS '
NOMBRE: validar_usuarios
TIPO: Function (store procedure)
PARAMETROS: 
	1:  Nombre de la empresa 
	2:  Login de la empresa
	3:  Password de seguridad

EJEMPLO: SELECT str_mods FROM validar_usuarios(''hitokiri83'',''123'',''adm'');

';


SET default_tablespace = saib;

SET default_with_oids = false;

--
-- TOC entry 1662 (class 1259 OID 17106)
-- Dependencies: 6
-- Name: animales; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE animales (
    id_ani integer NOT NULL,
    nom_ani character varying(20)
);


ALTER TABLE public.animales OWNER TO desarrollo_g;

--
-- TOC entry 1663 (class 1259 OID 17109)
-- Dependencies: 1662 6
-- Name: animales_id_ani_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE animales_id_ani_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.animales_id_ani_seq OWNER TO desarrollo_g;

--
-- TOC entry 2358 (class 0 OID 0)
-- Dependencies: 1663
-- Name: animales_id_ani_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE animales_id_ani_seq OWNED BY animales.id_ani;


--
-- TOC entry 2359 (class 0 OID 0)
-- Dependencies: 1663
-- Name: animales_id_ani_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('animales_id_ani_seq', 1, false);


--
-- TOC entry 1664 (class 1259 OID 17111)
-- Dependencies: 6
-- Name: antecedentes_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE antecedentes_pacientes (
    id_ant_pac integer NOT NULL,
    id_ant_per integer NOT NULL,
    id_pac integer
);


ALTER TABLE public.antecedentes_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1665 (class 1259 OID 17114)
-- Dependencies: 6 1664
-- Name: antecedentes_pacientes_id_ant_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE antecedentes_pacientes_id_ant_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.antecedentes_pacientes_id_ant_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2360 (class 0 OID 0)
-- Dependencies: 1665
-- Name: antecedentes_pacientes_id_ant_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE antecedentes_pacientes_id_ant_pac_seq OWNED BY antecedentes_pacientes.id_ant_pac;


--
-- TOC entry 2361 (class 0 OID 0)
-- Dependencies: 1665
-- Name: antecedentes_pacientes_id_ant_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('antecedentes_pacientes_id_ant_pac_seq', 28, true);


--
-- TOC entry 1666 (class 1259 OID 17116)
-- Dependencies: 6
-- Name: antecedentes_personales; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE antecedentes_personales (
    id_ant_per integer NOT NULL,
    nom_ant_per character varying(100)
);


ALTER TABLE public.antecedentes_personales OWNER TO desarrollo_g;

--
-- TOC entry 1667 (class 1259 OID 17119)
-- Dependencies: 1666 6
-- Name: antecedentes_personales_id_ant_per_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE antecedentes_personales_id_ant_per_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.antecedentes_personales_id_ant_per_seq OWNER TO desarrollo_g;

--
-- TOC entry 2362 (class 0 OID 0)
-- Dependencies: 1667
-- Name: antecedentes_personales_id_ant_per_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE antecedentes_personales_id_ant_per_seq OWNED BY antecedentes_personales.id_ant_per;


--
-- TOC entry 2363 (class 0 OID 0)
-- Dependencies: 1667
-- Name: antecedentes_personales_id_ant_per_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('antecedentes_personales_id_ant_per_seq', 1, false);


--
-- TOC entry 1668 (class 1259 OID 17121)
-- Dependencies: 6
-- Name: auditoria_transacciones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE auditoria_transacciones (
    id_aud_tra integer NOT NULL,
    fec_aud_tra timestamp without time zone,
    id_tip_usu_usu integer NOT NULL,
    id_tip_tra integer NOT NULL,
    data_xml xml
);


ALTER TABLE public.auditoria_transacciones OWNER TO desarrollo_g;

--
-- TOC entry 2364 (class 0 OID 0)
-- Dependencies: 1668
-- Name: TABLE auditoria_transacciones; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON TABLE auditoria_transacciones IS 'Se guarda todos los eventos generados por los usuarios';


--
-- TOC entry 2365 (class 0 OID 0)
-- Dependencies: 1668
-- Name: COLUMN auditoria_transacciones.data_xml; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN auditoria_transacciones.data_xml IS 'Se guarda las modificaciones de la tabla y atributos realizada por los usuarios, todo en forma de XML';


--
-- TOC entry 1669 (class 1259 OID 17124)
-- Dependencies: 6 1668
-- Name: auditoria_transacciones_id_aud_tra_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE auditoria_transacciones_id_aud_tra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auditoria_transacciones_id_aud_tra_seq OWNER TO desarrollo_g;

--
-- TOC entry 2366 (class 0 OID 0)
-- Dependencies: 1669
-- Name: auditoria_transacciones_id_aud_tra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE auditoria_transacciones_id_aud_tra_seq OWNED BY auditoria_transacciones.id_aud_tra;


--
-- TOC entry 2367 (class 0 OID 0)
-- Dependencies: 1669
-- Name: auditoria_transacciones_id_aud_tra_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('auditoria_transacciones_id_aud_tra_seq', 3, true);


--
-- TOC entry 1670 (class 1259 OID 17126)
-- Dependencies: 6
-- Name: categorias__cuerpos_micosis; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE categorias__cuerpos_micosis (
    id_cat_cue_mic integer NOT NULL,
    id_cat_cue integer NOT NULL,
    id_tip_mic integer NOT NULL
);


ALTER TABLE public.categorias__cuerpos_micosis OWNER TO desarrollo_g;

--
-- TOC entry 1671 (class 1259 OID 17129)
-- Dependencies: 1670 6
-- Name: categorias__cuerpos_micosis_id_cat_cue_mic_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE categorias__cuerpos_micosis_id_cat_cue_mic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorias__cuerpos_micosis_id_cat_cue_mic_seq OWNER TO desarrollo_g;

--
-- TOC entry 2368 (class 0 OID 0)
-- Dependencies: 1671
-- Name: categorias__cuerpos_micosis_id_cat_cue_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE categorias__cuerpos_micosis_id_cat_cue_mic_seq OWNED BY categorias__cuerpos_micosis.id_cat_cue_mic;


--
-- TOC entry 2369 (class 0 OID 0)
-- Dependencies: 1671
-- Name: categorias__cuerpos_micosis_id_cat_cue_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('categorias__cuerpos_micosis_id_cat_cue_mic_seq', 3, false);


--
-- TOC entry 1672 (class 1259 OID 17131)
-- Dependencies: 6
-- Name: categorias_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE categorias_cuerpos (
    id_cat_cue integer NOT NULL,
    nom_cat_cue character varying(20)
);


ALTER TABLE public.categorias_cuerpos OWNER TO desarrollo_g;

--
-- TOC entry 1694 (class 1259 OID 17209)
-- Dependencies: 6
-- Name: categorias_cuerpos__lesiones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE categorias_cuerpos__lesiones (
    id_cat_cue_les integer NOT NULL,
    id_les integer,
    id_cat_cue integer
);


ALTER TABLE public.categorias_cuerpos__lesiones OWNER TO desarrollo_g;

--
-- TOC entry 1673 (class 1259 OID 17134)
-- Dependencies: 6 1672
-- Name: categorias_cuerpos_id_cat_cue_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE categorias_cuerpos_id_cat_cue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorias_cuerpos_id_cat_cue_seq OWNER TO desarrollo_g;

--
-- TOC entry 2370 (class 0 OID 0)
-- Dependencies: 1673
-- Name: categorias_cuerpos_id_cat_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE categorias_cuerpos_id_cat_cue_seq OWNED BY categorias_cuerpos.id_cat_cue;


--
-- TOC entry 2371 (class 0 OID 0)
-- Dependencies: 1673
-- Name: categorias_cuerpos_id_cat_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('categorias_cuerpos_id_cat_cue_seq', 4, false);


SET default_tablespace = '';

--
-- TOC entry 1741 (class 1259 OID 18773)
-- Dependencies: 6
-- Name: centro_salud_doctores; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE centro_salud_doctores (
    id_cen_sal_doc integer NOT NULL,
    id_cen_sal integer NOT NULL,
    id_doc integer NOT NULL,
    otr_cen_sal character varying(100)
);


ALTER TABLE public.centro_salud_doctores OWNER TO desarrollo_g;

--
-- TOC entry 2372 (class 0 OID 0)
-- Dependencies: 1741
-- Name: COLUMN centro_salud_doctores.id_cen_sal_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.id_cen_sal_doc IS 'Identificación del Centro de Salud del doctor';


--
-- TOC entry 2373 (class 0 OID 0)
-- Dependencies: 1741
-- Name: COLUMN centro_salud_doctores.id_cen_sal; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.id_cen_sal IS 'Identificación del Centro de Salud';


--
-- TOC entry 2374 (class 0 OID 0)
-- Dependencies: 1741
-- Name: COLUMN centro_salud_doctores.id_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.id_doc IS 'Identificación del doctor';


--
-- TOC entry 2375 (class 0 OID 0)
-- Dependencies: 1741
-- Name: COLUMN centro_salud_doctores.otr_cen_sal; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.otr_cen_sal IS 'Otro Centro de Salud';


--
-- TOC entry 1740 (class 1259 OID 18771)
-- Dependencies: 1741 6
-- Name: centro_salud_doctores_id_cen_sal_doc_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE centro_salud_doctores_id_cen_sal_doc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.centro_salud_doctores_id_cen_sal_doc_seq OWNER TO desarrollo_g;

--
-- TOC entry 2376 (class 0 OID 0)
-- Dependencies: 1740
-- Name: centro_salud_doctores_id_cen_sal_doc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE centro_salud_doctores_id_cen_sal_doc_seq OWNED BY centro_salud_doctores.id_cen_sal_doc;


--
-- TOC entry 2377 (class 0 OID 0)
-- Dependencies: 1740
-- Name: centro_salud_doctores_id_cen_sal_doc_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('centro_salud_doctores_id_cen_sal_doc_seq', 11, true);


SET default_tablespace = saib;

--
-- TOC entry 1674 (class 1259 OID 17141)
-- Dependencies: 6
-- Name: centro_saluds; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE centro_saluds (
    id_cen_sal integer NOT NULL,
    nom_cen_sal character varying(100) NOT NULL,
    des_cen_sal character varying(100)
);


ALTER TABLE public.centro_saluds OWNER TO desarrollo_g;

--
-- TOC entry 1675 (class 1259 OID 17144)
-- Dependencies: 6 1674
-- Name: centro_salud_id_cen_sal_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE centro_salud_id_cen_sal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.centro_salud_id_cen_sal_seq OWNER TO desarrollo_g;

--
-- TOC entry 2378 (class 0 OID 0)
-- Dependencies: 1675
-- Name: centro_salud_id_cen_sal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE centro_salud_id_cen_sal_seq OWNED BY centro_saluds.id_cen_sal;


--
-- TOC entry 2379 (class 0 OID 0)
-- Dependencies: 1675
-- Name: centro_salud_id_cen_sal_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('centro_salud_id_cen_sal_seq', 34, true);


--
-- TOC entry 1676 (class 1259 OID 17146)
-- Dependencies: 6
-- Name: centro_salud_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE centro_salud_pacientes (
    id_cen_sal_pac integer NOT NULL,
    id_his integer NOT NULL,
    id_cen_sal integer NOT NULL,
    otr_cen_sal character varying(20)
);


ALTER TABLE public.centro_salud_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1677 (class 1259 OID 17149)
-- Dependencies: 6 1676
-- Name: centro_salud_pacientes_id_cen_sal_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE centro_salud_pacientes_id_cen_sal_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.centro_salud_pacientes_id_cen_sal_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2380 (class 0 OID 0)
-- Dependencies: 1677
-- Name: centro_salud_pacientes_id_cen_sal_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE centro_salud_pacientes_id_cen_sal_pac_seq OWNED BY centro_salud_pacientes.id_cen_sal_pac;


--
-- TOC entry 2381 (class 0 OID 0)
-- Dependencies: 1677
-- Name: centro_salud_pacientes_id_cen_sal_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('centro_salud_pacientes_id_cen_sal_pac_seq', 61, true);


--
-- TOC entry 1678 (class 1259 OID 17161)
-- Dependencies: 6
-- Name: contactos_animales; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE contactos_animales (
    id_con_ani integer NOT NULL,
    id_his integer NOT NULL,
    id_ani integer NOT NULL,
    otr_ani character varying(20)
);


ALTER TABLE public.contactos_animales OWNER TO desarrollo_g;

--
-- TOC entry 1679 (class 1259 OID 17164)
-- Dependencies: 6 1678
-- Name: contactos_animales_id_con_ani_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE contactos_animales_id_con_ani_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contactos_animales_id_con_ani_seq OWNER TO desarrollo_g;

--
-- TOC entry 2382 (class 0 OID 0)
-- Dependencies: 1679
-- Name: contactos_animales_id_con_ani_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE contactos_animales_id_con_ani_seq OWNED BY contactos_animales.id_con_ani;


--
-- TOC entry 2383 (class 0 OID 0)
-- Dependencies: 1679
-- Name: contactos_animales_id_con_ani_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('contactos_animales_id_con_ani_seq', 33, true);


--
-- TOC entry 1680 (class 1259 OID 17166)
-- Dependencies: 2044 6
-- Name: doctores; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE doctores (
    id_doc integer NOT NULL,
    nom_doc character varying(100),
    ape_doc character varying(100),
    ced_doc character varying(20),
    pas_doc character varying(100),
    tel_doc character varying(100),
    cor_doc character varying(100),
    log_doc character varying(100),
    fec_reg_doc timestamp with time zone DEFAULT now()
);


ALTER TABLE public.doctores OWNER TO desarrollo_g;

--
-- TOC entry 2384 (class 0 OID 0)
-- Dependencies: 1680
-- Name: TABLE doctores; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON TABLE doctores IS 'Registro de todos los doctores que del aplicativo';


--
-- TOC entry 2385 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.id_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.id_doc IS 'identificador único para los doctores';


--
-- TOC entry 2386 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.nom_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.nom_doc IS 'Nombre del doctor';


--
-- TOC entry 2387 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.ape_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.ape_doc IS 'Apellido del doctor';


--
-- TOC entry 2388 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.ced_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.ced_doc IS 'Cédula del doctor';


--
-- TOC entry 2389 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.pas_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.pas_doc IS 'Contraseña del doctor';


--
-- TOC entry 2390 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.tel_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.tel_doc IS 'Teléfono del doctor';


--
-- TOC entry 2391 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.cor_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.cor_doc IS 'Correo electronico del doctor';


--
-- TOC entry 2392 (class 0 OID 0)
-- Dependencies: 1680
-- Name: COLUMN doctores.log_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.log_doc IS 'Login con el que se loguara el doctor';


--
-- TOC entry 1681 (class 1259 OID 17172)
-- Dependencies: 6 1680
-- Name: doctores_id_doc_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE doctores_id_doc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctores_id_doc_seq OWNER TO desarrollo_g;

--
-- TOC entry 2393 (class 0 OID 0)
-- Dependencies: 1681
-- Name: doctores_id_doc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE doctores_id_doc_seq OWNED BY doctores.id_doc;


--
-- TOC entry 2394 (class 0 OID 0)
-- Dependencies: 1681
-- Name: doctores_id_doc_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('doctores_id_doc_seq', 34, true);


--
-- TOC entry 1682 (class 1259 OID 17174)
-- Dependencies: 6
-- Name: enfermedades_micologicas; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE enfermedades_micologicas (
    id_enf_mic integer NOT NULL,
    nom_enf_mic character varying(100) NOT NULL,
    id_tip_mic integer NOT NULL
);


ALTER TABLE public.enfermedades_micologicas OWNER TO desarrollo_g;

--
-- TOC entry 1683 (class 1259 OID 17177)
-- Dependencies: 6 1682
-- Name: enfermedades_micologicas_id_enf_mic_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE enfermedades_micologicas_id_enf_mic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enfermedades_micologicas_id_enf_mic_seq OWNER TO desarrollo_g;

--
-- TOC entry 2395 (class 0 OID 0)
-- Dependencies: 1683
-- Name: enfermedades_micologicas_id_enf_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE enfermedades_micologicas_id_enf_mic_seq OWNED BY enfermedades_micologicas.id_enf_mic;


--
-- TOC entry 2396 (class 0 OID 0)
-- Dependencies: 1683
-- Name: enfermedades_micologicas_id_enf_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('enfermedades_micologicas_id_enf_mic_seq', 26, false);


--
-- TOC entry 1684 (class 1259 OID 17179)
-- Dependencies: 6
-- Name: enfermedades_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE enfermedades_pacientes (
    id_enf_pac integer NOT NULL,
    id_enf_mic integer NOT NULL,
    otr_enf_mic character varying(20),
    esp_enf_mic character varying(20),
    id_tip_mic_pac integer
);


ALTER TABLE public.enfermedades_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1685 (class 1259 OID 17182)
-- Dependencies: 6 1684
-- Name: enfermedades_pacientes_id_enf_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE enfermedades_pacientes_id_enf_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enfermedades_pacientes_id_enf_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2397 (class 0 OID 0)
-- Dependencies: 1685
-- Name: enfermedades_pacientes_id_enf_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE enfermedades_pacientes_id_enf_pac_seq OWNED BY enfermedades_pacientes.id_enf_pac;


--
-- TOC entry 2398 (class 0 OID 0)
-- Dependencies: 1685
-- Name: enfermedades_pacientes_id_enf_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('enfermedades_pacientes_id_enf_pac_seq', 149, true);


SET default_tablespace = '';

--
-- TOC entry 1735 (class 1259 OID 18420)
-- Dependencies: 6
-- Name: estados; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE estados (
    id_est integer NOT NULL,
    des_est character varying(100),
    id_pai integer
);


ALTER TABLE public.estados OWNER TO desarrollo_g;

--
-- TOC entry 1734 (class 1259 OID 18418)
-- Dependencies: 6 1735
-- Name: estados_id_est_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE estados_id_est_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estados_id_est_seq OWNER TO desarrollo_g;

--
-- TOC entry 2399 (class 0 OID 0)
-- Dependencies: 1734
-- Name: estados_id_est_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE estados_id_est_seq OWNED BY estados.id_est;


--
-- TOC entry 2400 (class 0 OID 0)
-- Dependencies: 1734
-- Name: estados_id_est_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('estados_id_est_seq', 6, true);


SET default_tablespace = saib;

--
-- TOC entry 1686 (class 1259 OID 17189)
-- Dependencies: 6
-- Name: forma_infecciones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE forma_infecciones (
    id_for_inf integer NOT NULL,
    des_for_inf character varying(20)
);


ALTER TABLE public.forma_infecciones OWNER TO desarrollo_g;

--
-- TOC entry 1687 (class 1259 OID 17192)
-- Dependencies: 6
-- Name: forma_infecciones__pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE forma_infecciones__pacientes (
    id_for_pac integer NOT NULL,
    id_for_inf integer NOT NULL,
    otr_for_inf character varying(20),
    id_tip_mic_pac integer
);


ALTER TABLE public.forma_infecciones__pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1688 (class 1259 OID 17195)
-- Dependencies: 1687 6
-- Name: forma_infecciones__pacientes_id_for_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE forma_infecciones__pacientes_id_for_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forma_infecciones__pacientes_id_for_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2401 (class 0 OID 0)
-- Dependencies: 1688
-- Name: forma_infecciones__pacientes_id_for_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE forma_infecciones__pacientes_id_for_pac_seq OWNED BY forma_infecciones__pacientes.id_for_pac;


--
-- TOC entry 2402 (class 0 OID 0)
-- Dependencies: 1688
-- Name: forma_infecciones__pacientes_id_for_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('forma_infecciones__pacientes_id_for_pac_seq', 1, false);


--
-- TOC entry 1689 (class 1259 OID 17197)
-- Dependencies: 6
-- Name: forma_infecciones__tipos_micosis; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE forma_infecciones__tipos_micosis (
    id_for_inf_tip_mic integer NOT NULL,
    id_tip_mic integer NOT NULL,
    id_for_inf integer NOT NULL
);


ALTER TABLE public.forma_infecciones__tipos_micosis OWNER TO desarrollo_g;

--
-- TOC entry 1690 (class 1259 OID 17200)
-- Dependencies: 6 1689
-- Name: forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq OWNER TO desarrollo_g;

--
-- TOC entry 2403 (class 0 OID 0)
-- Dependencies: 1690
-- Name: forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq OWNED BY forma_infecciones__tipos_micosis.id_for_inf_tip_mic;


--
-- TOC entry 2404 (class 0 OID 0)
-- Dependencies: 1690
-- Name: forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq', 1, false);


--
-- TOC entry 1691 (class 1259 OID 17202)
-- Dependencies: 1686 6
-- Name: forma_infecciones_id_for_inf_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE forma_infecciones_id_for_inf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forma_infecciones_id_for_inf_seq OWNER TO desarrollo_g;

--
-- TOC entry 2405 (class 0 OID 0)
-- Dependencies: 1691
-- Name: forma_infecciones_id_for_inf_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE forma_infecciones_id_for_inf_seq OWNED BY forma_infecciones.id_for_inf;


--
-- TOC entry 2406 (class 0 OID 0)
-- Dependencies: 1691
-- Name: forma_infecciones_id_for_inf_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('forma_infecciones_id_for_inf_seq', 1, false);


--
-- TOC entry 1692 (class 1259 OID 17204)
-- Dependencies: 2051 6
-- Name: historiales_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE historiales_pacientes (
    id_his integer NOT NULL,
    id_pac integer NOT NULL,
    des_his character varying(255),
    id_doc integer,
    des_adi_pac_his character varying(255),
    fec_his timestamp with time zone DEFAULT now()
);


ALTER TABLE public.historiales_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2407 (class 0 OID 0)
-- Dependencies: 1692
-- Name: COLUMN historiales_pacientes.des_adi_pac_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN historiales_pacientes.des_adi_pac_his IS '
	Discripción adicional de si el paciente padece o no una enfermedad u otra cosa adicional.
';


--
-- TOC entry 1693 (class 1259 OID 17207)
-- Dependencies: 1692 6
-- Name: historiales_pacientes_id_his_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE historiales_pacientes_id_his_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historiales_pacientes_id_his_seq OWNER TO desarrollo_g;

--
-- TOC entry 2408 (class 0 OID 0)
-- Dependencies: 1693
-- Name: historiales_pacientes_id_his_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE historiales_pacientes_id_his_seq OWNED BY historiales_pacientes.id_his;


--
-- TOC entry 2409 (class 0 OID 0)
-- Dependencies: 1693
-- Name: historiales_pacientes_id_his_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('historiales_pacientes_id_his_seq', 16, true);


SET default_tablespace = '';

--
-- TOC entry 1746 (class 1259 OID 19087)
-- Dependencies: 6
-- Name: lesiones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE lesiones (
    id_les integer NOT NULL,
    nom_les character varying(100)
);


ALTER TABLE public.lesiones OWNER TO desarrollo_g;

--
-- TOC entry 1695 (class 1259 OID 17212)
-- Dependencies: 6 1694
-- Name: lesiones__partes_cuerpos_id_les_par_cue_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE lesiones__partes_cuerpos_id_les_par_cue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesiones__partes_cuerpos_id_les_par_cue_seq OWNER TO desarrollo_g;

--
-- TOC entry 2410 (class 0 OID 0)
-- Dependencies: 1695
-- Name: lesiones__partes_cuerpos_id_les_par_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE lesiones__partes_cuerpos_id_les_par_cue_seq OWNED BY categorias_cuerpos__lesiones.id_cat_cue_les;


--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 1695
-- Name: lesiones__partes_cuerpos_id_les_par_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('lesiones__partes_cuerpos_id_les_par_cue_seq', 9, true);


--
-- TOC entry 1745 (class 1259 OID 19085)
-- Dependencies: 1746 6
-- Name: lesiones_id_les_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE lesiones_id_les_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesiones_id_les_seq OWNER TO desarrollo_g;

--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 1745
-- Name: lesiones_id_les_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE lesiones_id_les_seq OWNED BY lesiones.id_les;


--
-- TOC entry 2413 (class 0 OID 0)
-- Dependencies: 1745
-- Name: lesiones_id_les_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('lesiones_id_les_seq', 20, false);


SET default_tablespace = saib;

--
-- TOC entry 1696 (class 1259 OID 17214)
-- Dependencies: 6
-- Name: lesiones_partes_cuerpos__pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE lesiones_partes_cuerpos__pacientes (
    id_les_par_cue_pac integer NOT NULL,
    otr_les_par_cue character varying(20),
    id_cat_cue_les integer,
    id_par_cue_cat_cue integer,
    id_tip_mic_pac integer
);


ALTER TABLE public.lesiones_partes_cuerpos__pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2414 (class 0 OID 0)
-- Dependencies: 1696
-- Name: COLUMN lesiones_partes_cuerpos__pacientes.id_les_par_cue_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN lesiones_partes_cuerpos__pacientes.id_les_par_cue_pac IS 'Leciones parted del cuerpo paciente';


--
-- TOC entry 2415 (class 0 OID 0)
-- Dependencies: 1696
-- Name: COLUMN lesiones_partes_cuerpos__pacientes.otr_les_par_cue; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN lesiones_partes_cuerpos__pacientes.otr_les_par_cue IS 'Otras leciones de la parte del cuerpo del paciente';


--
-- TOC entry 1697 (class 1259 OID 17217)
-- Dependencies: 6 1696
-- Name: lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2416 (class 0 OID 0)
-- Dependencies: 1697
-- Name: lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq OWNED BY lesiones_partes_cuerpos__pacientes.id_les_par_cue_pac;


--
-- TOC entry 2417 (class 0 OID 0)
-- Dependencies: 1697
-- Name: lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq', 160, true);


--
-- TOC entry 1698 (class 1259 OID 17219)
-- Dependencies: 6
-- Name: localizaciones_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE localizaciones_cuerpos (
    id_loc_cue integer NOT NULL,
    nom_loc_cue character varying(20) NOT NULL,
    id_par_cue integer
);


ALTER TABLE public.localizaciones_cuerpos OWNER TO desarrollo_g;

--
-- TOC entry 1699 (class 1259 OID 17222)
-- Dependencies: 6 1698
-- Name: localizaciones_cuerpos_id_loc_cue_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE localizaciones_cuerpos_id_loc_cue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.localizaciones_cuerpos_id_loc_cue_seq OWNER TO desarrollo_g;

--
-- TOC entry 2418 (class 0 OID 0)
-- Dependencies: 1699
-- Name: localizaciones_cuerpos_id_loc_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE localizaciones_cuerpos_id_loc_cue_seq OWNED BY localizaciones_cuerpos.id_loc_cue;


--
-- TOC entry 2419 (class 0 OID 0)
-- Dependencies: 1699
-- Name: localizaciones_cuerpos_id_loc_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('localizaciones_cuerpos_id_loc_cue_seq', 1, false);


--
-- TOC entry 1700 (class 1259 OID 17229)
-- Dependencies: 6
-- Name: modulos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE modulos (
    id_mod integer NOT NULL,
    cod_mod character varying(3),
    des_mod character varying(100),
    id_tip_usu integer
);


ALTER TABLE public.modulos OWNER TO desarrollo_g;

--
-- TOC entry 1701 (class 1259 OID 17232)
-- Dependencies: 6 1700
-- Name: modulos_id_mod_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE modulos_id_mod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.modulos_id_mod_seq OWNER TO desarrollo_g;

--
-- TOC entry 2420 (class 0 OID 0)
-- Dependencies: 1701
-- Name: modulos_id_mod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE modulos_id_mod_seq OWNED BY modulos.id_mod;


--
-- TOC entry 2421 (class 0 OID 0)
-- Dependencies: 1701
-- Name: modulos_id_mod_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('modulos_id_mod_seq', 2, true);


--
-- TOC entry 1702 (class 1259 OID 17234)
-- Dependencies: 6
-- Name: muestras_clinicas; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE muestras_clinicas (
    id_mue_cli integer NOT NULL,
    nom_mue_cli character varying(100) NOT NULL
);


ALTER TABLE public.muestras_clinicas OWNER TO desarrollo_g;

--
-- TOC entry 2422 (class 0 OID 0)
-- Dependencies: 1702
-- Name: COLUMN muestras_clinicas.id_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_clinicas.id_mue_cli IS 'Identificacion de la muestra clinica';


--
-- TOC entry 2423 (class 0 OID 0)
-- Dependencies: 1702
-- Name: COLUMN muestras_clinicas.nom_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_clinicas.nom_mue_cli IS 'Nombre muestra clinica';


--
-- TOC entry 1703 (class 1259 OID 17237)
-- Dependencies: 1702 6
-- Name: muestras_clinicas_id_mue_cli_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE muestras_clinicas_id_mue_cli_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muestras_clinicas_id_mue_cli_seq OWNER TO desarrollo_g;

--
-- TOC entry 2424 (class 0 OID 0)
-- Dependencies: 1703
-- Name: muestras_clinicas_id_mue_cli_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE muestras_clinicas_id_mue_cli_seq OWNED BY muestras_clinicas.id_mue_cli;


--
-- TOC entry 2425 (class 0 OID 0)
-- Dependencies: 1703
-- Name: muestras_clinicas_id_mue_cli_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('muestras_clinicas_id_mue_cli_seq', 1, false);


--
-- TOC entry 1704 (class 1259 OID 17239)
-- Dependencies: 6
-- Name: muestras_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE muestras_pacientes (
    id_mue_pac integer NOT NULL,
    id_his integer NOT NULL,
    id_mue_cli integer NOT NULL,
    otr_mue_cli character varying(20)
);


ALTER TABLE public.muestras_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2426 (class 0 OID 0)
-- Dependencies: 1704
-- Name: COLUMN muestras_pacientes.id_mue_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.id_mue_pac IS 'Id de la meustra del paciente';


--
-- TOC entry 2427 (class 0 OID 0)
-- Dependencies: 1704
-- Name: COLUMN muestras_pacientes.id_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.id_his IS 'Id del historial';


--
-- TOC entry 2428 (class 0 OID 0)
-- Dependencies: 1704
-- Name: COLUMN muestras_pacientes.id_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.id_mue_cli IS 'Id muestra cli';


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 1704
-- Name: COLUMN muestras_pacientes.otr_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.otr_mue_cli IS 'Otra meustra clinica';


--
-- TOC entry 1705 (class 1259 OID 17242)
-- Dependencies: 6 1704
-- Name: muestras_pacientes_id_mue_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE muestras_pacientes_id_mue_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muestras_pacientes_id_mue_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 1705
-- Name: muestras_pacientes_id_mue_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE muestras_pacientes_id_mue_pac_seq OWNED BY muestras_pacientes.id_mue_pac;


--
-- TOC entry 2431 (class 0 OID 0)
-- Dependencies: 1705
-- Name: muestras_pacientes_id_mue_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('muestras_pacientes_id_mue_pac_seq', 17, true);


SET default_tablespace = '';

--
-- TOC entry 1737 (class 1259 OID 18428)
-- Dependencies: 6
-- Name: municipios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE municipios (
    id_mun integer NOT NULL,
    des_mun character varying(100),
    id_est integer
);


ALTER TABLE public.municipios OWNER TO desarrollo_g;

--
-- TOC entry 1736 (class 1259 OID 18426)
-- Dependencies: 1737 6
-- Name: municipios_id_mun_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE municipios_id_mun_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.municipios_id_mun_seq OWNER TO desarrollo_g;

--
-- TOC entry 2432 (class 0 OID 0)
-- Dependencies: 1736
-- Name: municipios_id_mun_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE municipios_id_mun_seq OWNED BY municipios.id_mun;


--
-- TOC entry 2433 (class 0 OID 0)
-- Dependencies: 1736
-- Name: municipios_id_mun_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('municipios_id_mun_seq', 335, true);


SET default_tablespace = saib;

--
-- TOC entry 1706 (class 1259 OID 17244)
-- Dependencies: 2059 6
-- Name: pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE pacientes (
    id_pac integer NOT NULL,
    ape_pac character varying(20) NOT NULL,
    nom_pac character varying(100),
    ced_pac character varying(20),
    fec_nac_pac date NOT NULL,
    nac_pac character varying(100) NOT NULL,
    tel_hab_pac character varying(12),
    tel_cel_pac character varying(12),
    ocu_pac character varying(100),
    ciu_pac character varying(100),
    id_pai integer,
    id_est integer,
    id_mun integer,
    id_par integer,
    num_pac integer,
    id_doc integer,
    fec_reg_pac timestamp with time zone DEFAULT now()
);


ALTER TABLE public.pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2434 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.id_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.id_pac IS 'Id paciente';


--
-- TOC entry 2435 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.ape_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ape_pac IS 'Apellido del paciente';


--
-- TOC entry 2436 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.nom_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.nom_pac IS 'Nombre del paciente';


--
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.ced_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ced_pac IS 'Cedula del paciente';


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.fec_nac_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.fec_nac_pac IS 'Fecha de nacimiento del paciente';


--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.nac_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.nac_pac IS 'Nacionalidad del paciente';


--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.ocu_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ocu_pac IS 'Ocupacion del paciente';


--
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.ciu_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ciu_pac IS 'Ciudad del paciente';


--
-- TOC entry 2442 (class 0 OID 0)
-- Dependencies: 1706
-- Name: COLUMN pacientes.fec_reg_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.fec_reg_pac IS 'Fecha de registro del paciente';


--
-- TOC entry 1707 (class 1259 OID 17250)
-- Dependencies: 1706 6
-- Name: pacientes_id_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE pacientes_id_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacientes_id_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2443 (class 0 OID 0)
-- Dependencies: 1707
-- Name: pacientes_id_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE pacientes_id_pac_seq OWNED BY pacientes.id_pac;


--
-- TOC entry 2444 (class 0 OID 0)
-- Dependencies: 1707
-- Name: pacientes_id_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('pacientes_id_pac_seq', 28, true);


SET default_tablespace = '';

--
-- TOC entry 1733 (class 1259 OID 18412)
-- Dependencies: 6
-- Name: paises; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE paises (
    id_pai integer NOT NULL,
    des_pai character varying(100),
    cod_pai character varying(3)
);


ALTER TABLE public.paises OWNER TO desarrollo_g;

--
-- TOC entry 1732 (class 1259 OID 18410)
-- Dependencies: 6 1733
-- Name: paises_id_pai_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE paises_id_pai_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paises_id_pai_seq OWNER TO desarrollo_g;

--
-- TOC entry 2445 (class 0 OID 0)
-- Dependencies: 1732
-- Name: paises_id_pai_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE paises_id_pai_seq OWNED BY paises.id_pai;


--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 1732
-- Name: paises_id_pai_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('paises_id_pai_seq', 1, false);


--
-- TOC entry 1739 (class 1259 OID 18436)
-- Dependencies: 6
-- Name: parroquias; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE parroquias (
    id_par integer NOT NULL,
    des_par character varying(100),
    id_mun integer
);


ALTER TABLE public.parroquias OWNER TO desarrollo_g;

--
-- TOC entry 1738 (class 1259 OID 18434)
-- Dependencies: 1739 6
-- Name: parroquias_id_par_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE parroquias_id_par_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parroquias_id_par_seq OWNER TO desarrollo_g;

--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 1738
-- Name: parroquias_id_par_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE parroquias_id_par_seq OWNED BY parroquias.id_par;


--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 1738
-- Name: parroquias_id_par_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('parroquias_id_par_seq', 1, false);


SET default_tablespace = saib;

--
-- TOC entry 1708 (class 1259 OID 17252)
-- Dependencies: 6
-- Name: partes_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE partes_cuerpos (
    id_par_cue integer NOT NULL,
    nom_par_cue character varying(20)
);


ALTER TABLE public.partes_cuerpos OWNER TO desarrollo_g;

SET default_tablespace = '';

--
-- TOC entry 1748 (class 1259 OID 19125)
-- Dependencies: 6
-- Name: partes_cuerpos__categorias_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE partes_cuerpos__categorias_cuerpos (
    id_par_cue_cat_cue integer NOT NULL,
    id_cat_cue integer NOT NULL,
    id_par_cue integer NOT NULL
);


ALTER TABLE public.partes_cuerpos__categorias_cuerpos OWNER TO desarrollo_g;

--
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 1748
-- Name: TABLE partes_cuerpos__categorias_cuerpos; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON TABLE partes_cuerpos__categorias_cuerpos IS 'Permite seleccionar a que categoria pertenece la parte del cuerpo';


--
-- TOC entry 1747 (class 1259 OID 19123)
-- Dependencies: 1748 6
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq OWNER TO desarrollo_g;

--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 1747
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq OWNED BY partes_cuerpos__categorias_cuerpos.id_par_cue_cat_cue;


--
-- TOC entry 2451 (class 0 OID 0)
-- Dependencies: 1747
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq', 3, false);


--
-- TOC entry 1709 (class 1259 OID 17255)
-- Dependencies: 1708 6
-- Name: partes_cuerpos_id_par_cue_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE partes_cuerpos_id_par_cue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partes_cuerpos_id_par_cue_seq OWNER TO desarrollo_g;

--
-- TOC entry 2452 (class 0 OID 0)
-- Dependencies: 1709
-- Name: partes_cuerpos_id_par_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE partes_cuerpos_id_par_cue_seq OWNED BY partes_cuerpos.id_par_cue;


--
-- TOC entry 2453 (class 0 OID 0)
-- Dependencies: 1709
-- Name: partes_cuerpos_id_par_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('partes_cuerpos_id_par_cue_seq', 3, false);


--
-- TOC entry 1744 (class 1259 OID 18883)
-- Dependencies: 2079 6
-- Name: tiempo_evoluciones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tiempo_evoluciones (
    id_tie_evo integer NOT NULL,
    id_his integer,
    tie_evo integer DEFAULT 0
);


ALTER TABLE public.tiempo_evoluciones OWNER TO desarrollo_g;

--
-- TOC entry 1743 (class 1259 OID 18881)
-- Dependencies: 1744 6
-- Name: tiempo_evoluciones_id_tie_evo_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tiempo_evoluciones_id_tie_evo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tiempo_evoluciones_id_tie_evo_seq OWNER TO desarrollo_g;

--
-- TOC entry 2454 (class 0 OID 0)
-- Dependencies: 1743
-- Name: tiempo_evoluciones_id_tie_evo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tiempo_evoluciones_id_tie_evo_seq OWNED BY tiempo_evoluciones.id_tie_evo;


--
-- TOC entry 2455 (class 0 OID 0)
-- Dependencies: 1743
-- Name: tiempo_evoluciones_id_tie_evo_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tiempo_evoluciones_id_tie_evo_seq', 2, true);


SET default_tablespace = saib;

--
-- TOC entry 1710 (class 1259 OID 17262)
-- Dependencies: 6
-- Name: tipos_consultas; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_consultas (
    id_tip_con integer NOT NULL,
    nom_tip_con character varying(50) NOT NULL
);


ALTER TABLE public.tipos_consultas OWNER TO desarrollo_g;

--
-- TOC entry 2456 (class 0 OID 0)
-- Dependencies: 1710
-- Name: COLUMN tipos_consultas.id_tip_con; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas.id_tip_con IS 'id tipos consultas';


--
-- TOC entry 1711 (class 1259 OID 17265)
-- Dependencies: 6 1710
-- Name: tipos_consultas_id_tip_con_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_consultas_id_tip_con_seq
    START WITH 9
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_consultas_id_tip_con_seq OWNER TO desarrollo_g;

--
-- TOC entry 2457 (class 0 OID 0)
-- Dependencies: 1711
-- Name: tipos_consultas_id_tip_con_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_consultas_id_tip_con_seq OWNED BY tipos_consultas.id_tip_con;


--
-- TOC entry 2458 (class 0 OID 0)
-- Dependencies: 1711
-- Name: tipos_consultas_id_tip_con_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_consultas_id_tip_con_seq', 9, false);


--
-- TOC entry 1712 (class 1259 OID 17267)
-- Dependencies: 6
-- Name: tipos_consultas_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_consultas_pacientes (
    id_tip_con_pac integer NOT NULL,
    id_tip_con integer NOT NULL,
    id_his integer NOT NULL,
    otr_tip_con character varying(50)
);


ALTER TABLE public.tipos_consultas_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2459 (class 0 OID 0)
-- Dependencies: 1712
-- Name: COLUMN tipos_consultas_pacientes.id_tip_con_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.id_tip_con_pac IS 'Id tipos de consulta paciente';


--
-- TOC entry 2460 (class 0 OID 0)
-- Dependencies: 1712
-- Name: COLUMN tipos_consultas_pacientes.id_tip_con; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.id_tip_con IS 'Id tipos de consulta';


--
-- TOC entry 2461 (class 0 OID 0)
-- Dependencies: 1712
-- Name: COLUMN tipos_consultas_pacientes.id_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.id_his IS 'Id historico';


--
-- TOC entry 2462 (class 0 OID 0)
-- Dependencies: 1712
-- Name: COLUMN tipos_consultas_pacientes.otr_tip_con; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.otr_tip_con IS 'Otro tipo de consulta';


--
-- TOC entry 1713 (class 1259 OID 17270)
-- Dependencies: 6 1712
-- Name: tipos_consultas_pacientes_id_tip_con_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_consultas_pacientes_id_tip_con_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_consultas_pacientes_id_tip_con_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2463 (class 0 OID 0)
-- Dependencies: 1713
-- Name: tipos_consultas_pacientes_id_tip_con_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_consultas_pacientes_id_tip_con_pac_seq OWNED BY tipos_consultas_pacientes.id_tip_con_pac;


--
-- TOC entry 2464 (class 0 OID 0)
-- Dependencies: 1713
-- Name: tipos_consultas_pacientes_id_tip_con_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_consultas_pacientes_id_tip_con_pac_seq', 63, true);


--
-- TOC entry 1714 (class 1259 OID 17272)
-- Dependencies: 6
-- Name: tipos_estudios_micologicos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_estudios_micologicos (
    id_tip_est_mic integer NOT NULL,
    id_tip_mic integer NOT NULL,
    nom_tip_est_mic character varying(255),
    id_tip_exa integer
);


ALTER TABLE public.tipos_estudios_micologicos OWNER TO desarrollo_g;

--
-- TOC entry 1715 (class 1259 OID 17275)
-- Dependencies: 1714 6
-- Name: tipos_estudios_micologicos_id_tip_est_mic_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_estudios_micologicos_id_tip_est_mic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_estudios_micologicos_id_tip_est_mic_seq OWNER TO desarrollo_g;

--
-- TOC entry 2465 (class 0 OID 0)
-- Dependencies: 1715
-- Name: tipos_estudios_micologicos_id_tip_est_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_estudios_micologicos_id_tip_est_mic_seq OWNED BY tipos_estudios_micologicos.id_tip_est_mic;


--
-- TOC entry 2466 (class 0 OID 0)
-- Dependencies: 1715
-- Name: tipos_estudios_micologicos_id_tip_est_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_estudios_micologicos_id_tip_est_mic_seq', 25, false);


SET default_tablespace = '';

--
-- TOC entry 1752 (class 1259 OID 19279)
-- Dependencies: 6
-- Name: tipos_examenes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tipos_examenes (
    id_tip_exa integer NOT NULL,
    nom_tip_exa character varying(255)
);


ALTER TABLE public.tipos_examenes OWNER TO desarrollo_g;

--
-- TOC entry 1751 (class 1259 OID 19277)
-- Dependencies: 6 1752
-- Name: tipos_examenes_id_tip_exa_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_examenes_id_tip_exa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_examenes_id_tip_exa_seq OWNER TO desarrollo_g;

--
-- TOC entry 2467 (class 0 OID 0)
-- Dependencies: 1751
-- Name: tipos_examenes_id_tip_exa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_examenes_id_tip_exa_seq OWNED BY tipos_examenes.id_tip_exa;


--
-- TOC entry 2468 (class 0 OID 0)
-- Dependencies: 1751
-- Name: tipos_examenes_id_tip_exa_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_examenes_id_tip_exa_seq', 3, false);


SET default_tablespace = saib;

--
-- TOC entry 1716 (class 1259 OID 17277)
-- Dependencies: 6
-- Name: tipos_micosis; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_micosis (
    id_tip_mic integer NOT NULL,
    nom_tip_mic character varying(20)
);


ALTER TABLE public.tipos_micosis OWNER TO desarrollo_g;

--
-- TOC entry 1717 (class 1259 OID 17280)
-- Dependencies: 6 1716
-- Name: tipos_micosis_id_tip_mic_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_micosis_id_tip_mic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_micosis_id_tip_mic_seq OWNER TO desarrollo_g;

--
-- TOC entry 2469 (class 0 OID 0)
-- Dependencies: 1717
-- Name: tipos_micosis_id_tip_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_micosis_id_tip_mic_seq OWNED BY tipos_micosis.id_tip_mic;


--
-- TOC entry 2470 (class 0 OID 0)
-- Dependencies: 1717
-- Name: tipos_micosis_id_tip_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_micosis_id_tip_mic_seq', 4, false);


SET default_tablespace = '';

--
-- TOC entry 1750 (class 1259 OID 19170)
-- Dependencies: 6
-- Name: tipos_micosis_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tipos_micosis_pacientes (
    id_tip_mic_pac integer NOT NULL,
    id_tip_mic integer,
    id_his integer
);


ALTER TABLE public.tipos_micosis_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1754 (class 1259 OID 19305)
-- Dependencies: 6
-- Name: tipos_micosis_pacientes__tipos_estudios_micologicos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tipos_micosis_pacientes__tipos_estudios_micologicos (
    id_tip_mic_pac_tip_est_mic integer NOT NULL,
    id_tip_mic_pac integer,
    id_tip_est_mic integer
);


ALTER TABLE public.tipos_micosis_pacientes__tipos_estudios_micologicos OWNER TO desarrollo_g;

--
-- TOC entry 1753 (class 1259 OID 19303)
-- Dependencies: 6 1754
-- Name: tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq OWNER TO desarrollo_g;

--
-- TOC entry 2471 (class 0 OID 0)
-- Dependencies: 1753
-- Name: tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq OWNED BY tipos_micosis_pacientes__tipos_estudios_micologicos.id_tip_mic_pac_tip_est_mic;


--
-- TOC entry 2472 (class 0 OID 0)
-- Dependencies: 1753
-- Name: tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq', 21, true);


--
-- TOC entry 1749 (class 1259 OID 19168)
-- Dependencies: 1750 6
-- Name: tipos_micosis_pacientes_id_tip_mic_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_micosis_pacientes_id_tip_mic_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_micosis_pacientes_id_tip_mic_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2473 (class 0 OID 0)
-- Dependencies: 1749
-- Name: tipos_micosis_pacientes_id_tip_mic_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_micosis_pacientes_id_tip_mic_pac_seq OWNED BY tipos_micosis_pacientes.id_tip_mic_pac;


--
-- TOC entry 2474 (class 0 OID 0)
-- Dependencies: 1749
-- Name: tipos_micosis_pacientes_id_tip_mic_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_micosis_pacientes_id_tip_mic_pac_seq', 37, true);


SET default_tablespace = saib;

--
-- TOC entry 1718 (class 1259 OID 17282)
-- Dependencies: 6
-- Name: tipos_usuarios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_usuarios (
    id_tip_usu integer NOT NULL,
    cod_tip_usu character varying(3) NOT NULL,
    des_tip_usu character varying(100)
);


ALTER TABLE public.tipos_usuarios OWNER TO desarrollo_g;

--
-- TOC entry 1719 (class 1259 OID 17285)
-- Dependencies: 6
-- Name: tipos_usuarios__usuarios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_usuarios__usuarios (
    id_tip_usu_usu integer NOT NULL,
    id_doc integer,
    id_usu_adm integer,
    id_tip_usu integer NOT NULL
);


ALTER TABLE public.tipos_usuarios__usuarios OWNER TO desarrollo_g;

--
-- TOC entry 1720 (class 1259 OID 17288)
-- Dependencies: 6 1719
-- Name: tipos_usuarios__usuarios_id_tip_usu_usu_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_usuarios__usuarios_id_tip_usu_usu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_usuarios__usuarios_id_tip_usu_usu_seq OWNER TO desarrollo_g;

--
-- TOC entry 2475 (class 0 OID 0)
-- Dependencies: 1720
-- Name: tipos_usuarios__usuarios_id_tip_usu_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_usuarios__usuarios_id_tip_usu_usu_seq OWNED BY tipos_usuarios__usuarios.id_tip_usu_usu;


--
-- TOC entry 2476 (class 0 OID 0)
-- Dependencies: 1720
-- Name: tipos_usuarios__usuarios_id_tip_usu_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_usuarios__usuarios_id_tip_usu_usu_seq', 52, true);


--
-- TOC entry 1721 (class 1259 OID 17290)
-- Dependencies: 6 1718
-- Name: tipos_usuarios_id_tip_usu_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tipos_usuarios_id_tip_usu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipos_usuarios_id_tip_usu_seq OWNER TO desarrollo_g;

--
-- TOC entry 2477 (class 0 OID 0)
-- Dependencies: 1721
-- Name: tipos_usuarios_id_tip_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_usuarios_id_tip_usu_seq OWNED BY tipos_usuarios.id_tip_usu;


--
-- TOC entry 2478 (class 0 OID 0)
-- Dependencies: 1721
-- Name: tipos_usuarios_id_tip_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_usuarios_id_tip_usu_seq', 2, true);


--
-- TOC entry 1722 (class 1259 OID 17292)
-- Dependencies: 6
-- Name: transacciones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE transacciones (
    id_tip_tra integer NOT NULL,
    cod_tip_tra character varying(3) NOT NULL,
    des_tip_tra character varying(100),
    id_mod integer
);


ALTER TABLE public.transacciones OWNER TO desarrollo_g;

--
-- TOC entry 1723 (class 1259 OID 17295)
-- Dependencies: 6 1722
-- Name: transacciones_id_tip_tra_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE transacciones_id_tip_tra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transacciones_id_tip_tra_seq OWNER TO desarrollo_g;

--
-- TOC entry 2479 (class 0 OID 0)
-- Dependencies: 1723
-- Name: transacciones_id_tip_tra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE transacciones_id_tip_tra_seq OWNED BY transacciones.id_tip_tra;


--
-- TOC entry 2480 (class 0 OID 0)
-- Dependencies: 1723
-- Name: transacciones_id_tip_tra_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('transacciones_id_tip_tra_seq', 16, true);


--
-- TOC entry 1724 (class 1259 OID 17297)
-- Dependencies: 6
-- Name: transacciones_usuarios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE transacciones_usuarios (
    id_tip_tra integer NOT NULL,
    id_tip_usu_usu integer,
    id_tra_usu integer NOT NULL
);


ALTER TABLE public.transacciones_usuarios OWNER TO desarrollo_g;

--
-- TOC entry 1731 (class 1259 OID 18028)
-- Dependencies: 6 1724
-- Name: transacciones_usuarios_id_tra_usu_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE transacciones_usuarios_id_tra_usu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transacciones_usuarios_id_tra_usu_seq OWNER TO desarrollo_g;

--
-- TOC entry 2481 (class 0 OID 0)
-- Dependencies: 1731
-- Name: transacciones_usuarios_id_tra_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE transacciones_usuarios_id_tra_usu_seq OWNED BY transacciones_usuarios.id_tra_usu;


--
-- TOC entry 2482 (class 0 OID 0)
-- Dependencies: 1731
-- Name: transacciones_usuarios_id_tra_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('transacciones_usuarios_id_tra_usu_seq', 116, true);


--
-- TOC entry 1725 (class 1259 OID 17302)
-- Dependencies: 6
-- Name: tratamientos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tratamientos (
    id_tra integer NOT NULL,
    nom_tra character varying(100)
);


ALTER TABLE public.tratamientos OWNER TO desarrollo_g;

--
-- TOC entry 1726 (class 1259 OID 17305)
-- Dependencies: 6 1725
-- Name: tratamientos_id_tra_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tratamientos_id_tra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tratamientos_id_tra_seq OWNER TO desarrollo_g;

--
-- TOC entry 2483 (class 0 OID 0)
-- Dependencies: 1726
-- Name: tratamientos_id_tra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tratamientos_id_tra_seq OWNED BY tratamientos.id_tra;


--
-- TOC entry 2484 (class 0 OID 0)
-- Dependencies: 1726
-- Name: tratamientos_id_tra_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tratamientos_id_tra_seq', 1, false);


--
-- TOC entry 1727 (class 1259 OID 17307)
-- Dependencies: 6
-- Name: tratamientos_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tratamientos_pacientes (
    id_tra_pac integer NOT NULL,
    id_his integer NOT NULL,
    id_tra integer NOT NULL,
    otr_tra character varying(20)
);


ALTER TABLE public.tratamientos_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2485 (class 0 OID 0)
-- Dependencies: 1727
-- Name: COLUMN tratamientos_pacientes.id_tra_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.id_tra_pac IS 'Id transaccion paciente';


--
-- TOC entry 2486 (class 0 OID 0)
-- Dependencies: 1727
-- Name: COLUMN tratamientos_pacientes.id_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.id_his IS 'Id historico';


--
-- TOC entry 2487 (class 0 OID 0)
-- Dependencies: 1727
-- Name: COLUMN tratamientos_pacientes.id_tra; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.id_tra IS 'Id tratamiento';


--
-- TOC entry 2488 (class 0 OID 0)
-- Dependencies: 1727
-- Name: COLUMN tratamientos_pacientes.otr_tra; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.otr_tra IS 'Otro tratamiento';


--
-- TOC entry 1728 (class 1259 OID 17310)
-- Dependencies: 6 1727
-- Name: tratamientos_pacientes_id_tra_pac_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE tratamientos_pacientes_id_tra_pac_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tratamientos_pacientes_id_tra_pac_seq OWNER TO desarrollo_g;

--
-- TOC entry 2489 (class 0 OID 0)
-- Dependencies: 1728
-- Name: tratamientos_pacientes_id_tra_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tratamientos_pacientes_id_tra_pac_seq OWNED BY tratamientos_pacientes.id_tra_pac;


--
-- TOC entry 2490 (class 0 OID 0)
-- Dependencies: 1728
-- Name: tratamientos_pacientes_id_tra_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tratamientos_pacientes_id_tra_pac_seq', 79, true);


--
-- TOC entry 1729 (class 1259 OID 17312)
-- Dependencies: 2072 6
-- Name: usuarios_administrativos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE usuarios_administrativos (
    id_usu_adm integer NOT NULL,
    nom_usu_adm character varying(100),
    ape_usu_adm character varying(100),
    pas_usu_adm character varying(100),
    log_usu_adm character varying(100),
    tel_usu_adm character varying(20),
    fec_reg_usu_adm timestamp without time zone DEFAULT now(),
    adm_usu boolean
);


ALTER TABLE public.usuarios_administrativos OWNER TO desarrollo_g;

--
-- TOC entry 2491 (class 0 OID 0)
-- Dependencies: 1729
-- Name: COLUMN usuarios_administrativos.fec_reg_usu_adm; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN usuarios_administrativos.fec_reg_usu_adm IS 'Fecha de registro de los usuarios';


--
-- TOC entry 2492 (class 0 OID 0)
-- Dependencies: 1729
-- Name: COLUMN usuarios_administrativos.adm_usu; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN usuarios_administrativos.adm_usu IS '
	TRUE: si es un super usuario
	FALSE: si es usuario com limitaciones
';


--
-- TOC entry 1730 (class 1259 OID 17315)
-- Dependencies: 6 1729
-- Name: usuarios_administrativos_id_usu_adm_seq; Type: SEQUENCE; Schema: public; Owner: desarrollo_g
--

CREATE SEQUENCE usuarios_administrativos_id_usu_adm_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_administrativos_id_usu_adm_seq OWNER TO desarrollo_g;

--
-- TOC entry 2493 (class 0 OID 0)
-- Dependencies: 1730
-- Name: usuarios_administrativos_id_usu_adm_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE usuarios_administrativos_id_usu_adm_seq OWNED BY usuarios_administrativos.id_usu_adm;


--
-- TOC entry 2494 (class 0 OID 0)
-- Dependencies: 1730
-- Name: usuarios_administrativos_id_usu_adm_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('usuarios_administrativos_id_usu_adm_seq', 23, true);


--
-- TOC entry 1755 (class 1259 OID 19321)
-- Dependencies: 1842 6
-- Name: view_auditoria_transacciones; Type: VIEW; Schema: public; Owner: desarrollo_g
--

CREATE VIEW view_auditoria_transacciones AS
    SELECT at.id_tip_tra, to_char(at.fec_aud_tra, 'DD/MM/YYYY HH12:MI:SS AM'::text) AS fecha_tran, (((d.nom_doc)::text || ' '::text) || (d.ape_doc)::text) AS nom_ape_usu, d.log_doc AS log_usu, CASE WHEN (at.data_xml IS NOT NULL) THEN 'Si'::text ELSE 'No'::text END AS detalle, at.id_tip_usu_usu FROM ((auditoria_transacciones at LEFT JOIN tipos_usuarios__usuarios tuu USING (id_tip_usu_usu)) LEFT JOIN doctores d ON ((tuu.id_doc = d.id_doc))) ORDER BY to_char(at.fec_aud_tra, 'DD/MM/YYYY HH12:MI:SS AM'::text) DESC;


ALTER TABLE public.view_auditoria_transacciones OWNER TO desarrollo_g;

--
-- TOC entry 2034 (class 2604 OID 17317)
-- Dependencies: 1663 1662
-- Name: id_ani; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE animales ALTER COLUMN id_ani SET DEFAULT nextval('animales_id_ani_seq'::regclass);


--
-- TOC entry 2035 (class 2604 OID 17318)
-- Dependencies: 1665 1664
-- Name: id_ant_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE antecedentes_pacientes ALTER COLUMN id_ant_pac SET DEFAULT nextval('antecedentes_pacientes_id_ant_pac_seq'::regclass);


--
-- TOC entry 2036 (class 2604 OID 17319)
-- Dependencies: 1667 1666
-- Name: id_ant_per; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE antecedentes_personales ALTER COLUMN id_ant_per SET DEFAULT nextval('antecedentes_personales_id_ant_per_seq'::regclass);


--
-- TOC entry 2037 (class 2604 OID 17320)
-- Dependencies: 1669 1668
-- Name: id_aud_tra; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE auditoria_transacciones ALTER COLUMN id_aud_tra SET DEFAULT nextval('auditoria_transacciones_id_aud_tra_seq'::regclass);


--
-- TOC entry 2038 (class 2604 OID 17321)
-- Dependencies: 1671 1670
-- Name: id_cat_cue_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE categorias__cuerpos_micosis ALTER COLUMN id_cat_cue_mic SET DEFAULT nextval('categorias__cuerpos_micosis_id_cat_cue_mic_seq'::regclass);


--
-- TOC entry 2039 (class 2604 OID 17322)
-- Dependencies: 1673 1672
-- Name: id_cat_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE categorias_cuerpos ALTER COLUMN id_cat_cue SET DEFAULT nextval('categorias_cuerpos_id_cat_cue_seq'::regclass);


--
-- TOC entry 2052 (class 2604 OID 17337)
-- Dependencies: 1695 1694
-- Name: id_cat_cue_les; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE categorias_cuerpos__lesiones ALTER COLUMN id_cat_cue_les SET DEFAULT nextval('lesiones__partes_cuerpos_id_les_par_cue_seq'::regclass);


--
-- TOC entry 2077 (class 2604 OID 18776)
-- Dependencies: 1741 1740 1741
-- Name: id_cen_sal_doc; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE centro_salud_doctores ALTER COLUMN id_cen_sal_doc SET DEFAULT nextval('centro_salud_doctores_id_cen_sal_doc_seq'::regclass);


--
-- TOC entry 2041 (class 2604 OID 17325)
-- Dependencies: 1677 1676
-- Name: id_cen_sal_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE centro_salud_pacientes ALTER COLUMN id_cen_sal_pac SET DEFAULT nextval('centro_salud_pacientes_id_cen_sal_pac_seq'::regclass);


--
-- TOC entry 2040 (class 2604 OID 17324)
-- Dependencies: 1675 1674
-- Name: id_cen_sal; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE centro_saluds ALTER COLUMN id_cen_sal SET DEFAULT nextval('centro_salud_id_cen_sal_seq'::regclass);


--
-- TOC entry 2042 (class 2604 OID 17328)
-- Dependencies: 1679 1678
-- Name: id_con_ani; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE contactos_animales ALTER COLUMN id_con_ani SET DEFAULT nextval('contactos_animales_id_con_ani_seq'::regclass);


--
-- TOC entry 2043 (class 2604 OID 17329)
-- Dependencies: 1681 1680
-- Name: id_doc; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE doctores ALTER COLUMN id_doc SET DEFAULT nextval('doctores_id_doc_seq'::regclass);


--
-- TOC entry 2045 (class 2604 OID 17330)
-- Dependencies: 1683 1682
-- Name: id_enf_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE enfermedades_micologicas ALTER COLUMN id_enf_mic SET DEFAULT nextval('enfermedades_micologicas_id_enf_mic_seq'::regclass);


--
-- TOC entry 2046 (class 2604 OID 17331)
-- Dependencies: 1685 1684
-- Name: id_enf_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE enfermedades_pacientes ALTER COLUMN id_enf_pac SET DEFAULT nextval('enfermedades_pacientes_id_enf_pac_seq'::regclass);


--
-- TOC entry 2074 (class 2604 OID 18423)
-- Dependencies: 1735 1734 1735
-- Name: id_est; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE estados ALTER COLUMN id_est SET DEFAULT nextval('estados_id_est_seq'::regclass);


--
-- TOC entry 2047 (class 2604 OID 17333)
-- Dependencies: 1691 1686
-- Name: id_for_inf; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE forma_infecciones ALTER COLUMN id_for_inf SET DEFAULT nextval('forma_infecciones_id_for_inf_seq'::regclass);


--
-- TOC entry 2048 (class 2604 OID 17334)
-- Dependencies: 1688 1687
-- Name: id_for_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE forma_infecciones__pacientes ALTER COLUMN id_for_pac SET DEFAULT nextval('forma_infecciones__pacientes_id_for_pac_seq'::regclass);


--
-- TOC entry 2049 (class 2604 OID 17335)
-- Dependencies: 1690 1689
-- Name: id_for_inf_tip_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE forma_infecciones__tipos_micosis ALTER COLUMN id_for_inf_tip_mic SET DEFAULT nextval('forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq'::regclass);


--
-- TOC entry 2050 (class 2604 OID 17336)
-- Dependencies: 1693 1692
-- Name: id_his; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE historiales_pacientes ALTER COLUMN id_his SET DEFAULT nextval('historiales_pacientes_id_his_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 19090)
-- Dependencies: 1746 1745 1746
-- Name: id_les; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE lesiones ALTER COLUMN id_les SET DEFAULT nextval('lesiones_id_les_seq'::regclass);


--
-- TOC entry 2053 (class 2604 OID 17338)
-- Dependencies: 1697 1696
-- Name: id_les_par_cue_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE lesiones_partes_cuerpos__pacientes ALTER COLUMN id_les_par_cue_pac SET DEFAULT nextval('lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq'::regclass);


--
-- TOC entry 2054 (class 2604 OID 17339)
-- Dependencies: 1699 1698
-- Name: id_loc_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE localizaciones_cuerpos ALTER COLUMN id_loc_cue SET DEFAULT nextval('localizaciones_cuerpos_id_loc_cue_seq'::regclass);


--
-- TOC entry 2055 (class 2604 OID 17341)
-- Dependencies: 1701 1700
-- Name: id_mod; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE modulos ALTER COLUMN id_mod SET DEFAULT nextval('modulos_id_mod_seq'::regclass);


--
-- TOC entry 2056 (class 2604 OID 17342)
-- Dependencies: 1703 1702
-- Name: id_mue_cli; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE muestras_clinicas ALTER COLUMN id_mue_cli SET DEFAULT nextval('muestras_clinicas_id_mue_cli_seq'::regclass);


--
-- TOC entry 2057 (class 2604 OID 17343)
-- Dependencies: 1705 1704
-- Name: id_mue_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE muestras_pacientes ALTER COLUMN id_mue_pac SET DEFAULT nextval('muestras_pacientes_id_mue_pac_seq'::regclass);


--
-- TOC entry 2075 (class 2604 OID 18431)
-- Dependencies: 1736 1737 1737
-- Name: id_mun; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE municipios ALTER COLUMN id_mun SET DEFAULT nextval('municipios_id_mun_seq'::regclass);


--
-- TOC entry 2058 (class 2604 OID 17344)
-- Dependencies: 1707 1706
-- Name: id_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE pacientes ALTER COLUMN id_pac SET DEFAULT nextval('pacientes_id_pac_seq'::regclass);


--
-- TOC entry 2073 (class 2604 OID 18415)
-- Dependencies: 1732 1733 1733
-- Name: id_pai; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE paises ALTER COLUMN id_pai SET DEFAULT nextval('paises_id_pai_seq'::regclass);


--
-- TOC entry 2076 (class 2604 OID 18439)
-- Dependencies: 1739 1738 1739
-- Name: id_par; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE parroquias ALTER COLUMN id_par SET DEFAULT nextval('parroquias_id_par_seq'::regclass);


--
-- TOC entry 2060 (class 2604 OID 17345)
-- Dependencies: 1709 1708
-- Name: id_par_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE partes_cuerpos ALTER COLUMN id_par_cue SET DEFAULT nextval('partes_cuerpos_id_par_cue_seq'::regclass);


--
-- TOC entry 2081 (class 2604 OID 19128)
-- Dependencies: 1747 1748 1748
-- Name: id_par_cue_cat_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE partes_cuerpos__categorias_cuerpos ALTER COLUMN id_par_cue_cat_cue SET DEFAULT nextval('partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 18886)
-- Dependencies: 1744 1743 1744
-- Name: id_tie_evo; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tiempo_evoluciones ALTER COLUMN id_tie_evo SET DEFAULT nextval('tiempo_evoluciones_id_tie_evo_seq'::regclass);


--
-- TOC entry 2061 (class 2604 OID 17347)
-- Dependencies: 1711 1710
-- Name: id_tip_con; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_consultas ALTER COLUMN id_tip_con SET DEFAULT nextval('tipos_consultas_id_tip_con_seq'::regclass);


--
-- TOC entry 2062 (class 2604 OID 17348)
-- Dependencies: 1713 1712
-- Name: id_tip_con_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_consultas_pacientes ALTER COLUMN id_tip_con_pac SET DEFAULT nextval('tipos_consultas_pacientes_id_tip_con_pac_seq'::regclass);


--
-- TOC entry 2063 (class 2604 OID 17349)
-- Dependencies: 1715 1714
-- Name: id_tip_est_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_estudios_micologicos ALTER COLUMN id_tip_est_mic SET DEFAULT nextval('tipos_estudios_micologicos_id_tip_est_mic_seq'::regclass);


--
-- TOC entry 2083 (class 2604 OID 19282)
-- Dependencies: 1752 1751 1752
-- Name: id_tip_exa; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_examenes ALTER COLUMN id_tip_exa SET DEFAULT nextval('tipos_examenes_id_tip_exa_seq'::regclass);


--
-- TOC entry 2064 (class 2604 OID 17350)
-- Dependencies: 1717 1716
-- Name: id_tip_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_micosis ALTER COLUMN id_tip_mic SET DEFAULT nextval('tipos_micosis_id_tip_mic_seq'::regclass);


--
-- TOC entry 2082 (class 2604 OID 19173)
-- Dependencies: 1749 1750 1750
-- Name: id_tip_mic_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_micosis_pacientes ALTER COLUMN id_tip_mic_pac SET DEFAULT nextval('tipos_micosis_pacientes_id_tip_mic_pac_seq'::regclass);


--
-- TOC entry 2084 (class 2604 OID 19308)
-- Dependencies: 1753 1754 1754
-- Name: id_tip_mic_pac_tip_est_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_micosis_pacientes__tipos_estudios_micologicos ALTER COLUMN id_tip_mic_pac_tip_est_mic SET DEFAULT nextval('tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq'::regclass);


--
-- TOC entry 2065 (class 2604 OID 17351)
-- Dependencies: 1721 1718
-- Name: id_tip_usu; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_usuarios ALTER COLUMN id_tip_usu SET DEFAULT nextval('tipos_usuarios_id_tip_usu_seq'::regclass);


--
-- TOC entry 2066 (class 2604 OID 17352)
-- Dependencies: 1720 1719
-- Name: id_tip_usu_usu; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_usuarios__usuarios ALTER COLUMN id_tip_usu_usu SET DEFAULT nextval('tipos_usuarios__usuarios_id_tip_usu_usu_seq'::regclass);


--
-- TOC entry 2067 (class 2604 OID 17353)
-- Dependencies: 1723 1722
-- Name: id_tip_tra; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE transacciones ALTER COLUMN id_tip_tra SET DEFAULT nextval('transacciones_id_tip_tra_seq'::regclass);


--
-- TOC entry 2068 (class 2604 OID 18030)
-- Dependencies: 1731 1724
-- Name: id_tra_usu; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE transacciones_usuarios ALTER COLUMN id_tra_usu SET DEFAULT nextval('transacciones_usuarios_id_tra_usu_seq'::regclass);


--
-- TOC entry 2069 (class 2604 OID 17355)
-- Dependencies: 1726 1725
-- Name: id_tra; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tratamientos ALTER COLUMN id_tra SET DEFAULT nextval('tratamientos_id_tra_seq'::regclass);


--
-- TOC entry 2070 (class 2604 OID 17356)
-- Dependencies: 1728 1727
-- Name: id_tra_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tratamientos_pacientes ALTER COLUMN id_tra_pac SET DEFAULT nextval('tratamientos_pacientes_id_tra_pac_seq'::regclass);


--
-- TOC entry 2071 (class 2604 OID 17357)
-- Dependencies: 1730 1729
-- Name: id_usu_adm; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE usuarios_administrativos ALTER COLUMN id_usu_adm SET DEFAULT nextval('usuarios_administrativos_id_usu_adm_seq'::regclass);


--
-- TOC entry 2287 (class 0 OID 17106)
-- Dependencies: 1662
-- Data for Name: animales; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO animales (id_ani, nom_ani) VALUES (1, 'Perro');
INSERT INTO animales (id_ani, nom_ani) VALUES (2, 'Gato');
INSERT INTO animales (id_ani, nom_ani) VALUES (3, 'Aves');
INSERT INTO animales (id_ani, nom_ani) VALUES (4, 'Animales de Corral');
INSERT INTO animales (id_ani, nom_ani) VALUES (5, 'Otros');


--
-- TOC entry 2288 (class 0 OID 17111)
-- Dependencies: 1664
-- Data for Name: antecedentes_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (12, 2, 28);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (13, 3, 28);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (18, 2, 27);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (19, 3, 27);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (25, 1, 13);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (26, 9, 7);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (27, 11, 7);
INSERT INTO antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) VALUES (28, 12, 7);


--
-- TOC entry 2289 (class 0 OID 17116)
-- Dependencies: 1666
-- Data for Name: antecedentes_personales; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (1, 'Ninguna');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (2, 'Obesidad');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (3, 'Diabetes');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (4, 'Traumatismo');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (5, 'Cirugía');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (6, 'HIV/SIDA');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (7, 'Cáncer');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (8, 'inmunosupresión/Neutropenia');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (9, 'Uso Esteroides');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (10, 'Embarazo');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (11, 'Neoplasias');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (12, 'Inanición');
INSERT INTO antecedentes_personales (id_ant_per, nom_ant_per) VALUES (13, 'Otros');


--
-- TOC entry 2290 (class 0 OID 17121)
-- Dependencies: 1668
-- Data for Name: auditoria_transacciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO auditoria_transacciones (id_aud_tra, fec_aud_tra, id_tip_usu_usu, id_tip_tra, data_xml) VALUES (1, '2011-08-28 18:16:18.03', 17, 10, '<?xml version="1.0" standalone="yes"?><modificacion_de_pacientes>
				 <tabla nombre="pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Fecha Nacimiento"><actual>2011-09-06</actual><anterior>2011-09-06</anterior></campo><campo nombre="Nacionalidad"><actual>Venezolano</actual><anterior>Venezolano</anterior></campo><campo nombre="Teléfono Habitación"><actual>3622824</actual><anterior>3622824</anterior></campo><campo nombre="Teléfono Célular"><actual>04265168824</actual><anterior>04265168824</anterior></campo><campo nombre="Ocupación"><actual>Técnico</actual><anterior>Técnico</anterior></campo><campo nombre="País"><actual>Venezuela</actual><anterior>Venezuela</anterior></campo><campo nombre="Estado"><actual>Distrito Capital</actual><anterior>Distrito Capital</anterior></campo><campo nombre="Municipio"><actual>	Libertador Caracas		 </actual><anterior>	Libertador Caracas		 </anterior></campo><campo nombre="Ciudad"><actual>Guarenas</actual><anterior>Guarenas</anterior></campo></tabla><tabla nombre="antecedentes_personales"><campo nombre="Antecedentes Personales"><actual>Uso Esteroides ,Neoplasias ,Inanición </actual><anterior>Uso Esteroides ,Neoplasias ,Inanición </anterior></campo></tabla></modificacion_de_pacientes>');
INSERT INTO auditoria_transacciones (id_aud_tra, fec_aud_tra, id_tip_usu_usu, id_tip_tra, data_xml) VALUES (2, '2011-09-04 11:30:11.606', 17, 14, '<?xml version="1.0" standalone="yes"?><eliminacion_del_historial_paciente>
			 <tabla nombre="historiales_pacientes"><campo nombre="Nombre Paciente"><actual>ninguno</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido Paciente"><actual>ninguno</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula Paciente"><actual>ninguno</actual><anterior>17651233</anterior></campo><campo nombre="Descripción de la Historia"><actual>ninguno</actual><anterior></anterior></campo><campo nombre="Descripción Adicional"><actual>ninguno</actual><anterior></anterior></campo><campo nombre="Fecha de Historia"><actual>ninguno</actual><anterior>2011-07-08 12:11:11.417-04:30</anterior></campo></tabla></eliminacion_del_historial_paciente>');
INSERT INTO auditoria_transacciones (id_aud_tra, fec_aud_tra, id_tip_usu_usu, id_tip_tra, data_xml) VALUES (3, '2011-09-11 17:10:18.105', 17, 16, '<?xml version="1.0" standalone="yes"?><Información_adicional>
			 <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>');


--
-- TOC entry 2291 (class 0 OID 17126)
-- Dependencies: 1670
-- Data for Name: categorias__cuerpos_micosis; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO categorias__cuerpos_micosis (id_cat_cue_mic, id_cat_cue, id_tip_mic) VALUES (1, 1, 1);
INSERT INTO categorias__cuerpos_micosis (id_cat_cue_mic, id_cat_cue, id_tip_mic) VALUES (2, 2, 1);


--
-- TOC entry 2292 (class 0 OID 17131)
-- Dependencies: 1672
-- Data for Name: categorias_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO categorias_cuerpos (id_cat_cue, nom_cat_cue) VALUES (1, 'Uña');
INSERT INTO categorias_cuerpos (id_cat_cue, nom_cat_cue) VALUES (2, 'Cuerpo');
INSERT INTO categorias_cuerpos (id_cat_cue, nom_cat_cue) VALUES (3, 'Piel');


--
-- TOC entry 2303 (class 0 OID 17209)
-- Dependencies: 1694
-- Data for Name: categorias_cuerpos__lesiones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (2, 1, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (3, 2, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (4, 3, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (5, 4, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (6, 5, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (7, 6, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (8, 7, 1);
INSERT INTO categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) VALUES (9, 8, 1);


--
-- TOC entry 2326 (class 0 OID 18773)
-- Dependencies: 1741
-- Data for Name: centro_salud_doctores; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO centro_salud_doctores (id_cen_sal_doc, id_cen_sal, id_doc, otr_cen_sal) VALUES (5, 5, 33, NULL);
INSERT INTO centro_salud_doctores (id_cen_sal_doc, id_cen_sal, id_doc, otr_cen_sal) VALUES (6, 6, 6, NULL);
INSERT INTO centro_salud_doctores (id_cen_sal_doc, id_cen_sal, id_doc, otr_cen_sal) VALUES (9, 5, 34, NULL);
INSERT INTO centro_salud_doctores (id_cen_sal_doc, id_cen_sal, id_doc, otr_cen_sal) VALUES (11, 7, 32, NULL);


--
-- TOC entry 2294 (class 0 OID 17146)
-- Dependencies: 1676
-- Data for Name: centro_salud_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO centro_salud_pacientes (id_cen_sal_pac, id_his, id_cen_sal, otr_cen_sal) VALUES (58, 16, 5, NULL);
INSERT INTO centro_salud_pacientes (id_cen_sal_pac, id_his, id_cen_sal, otr_cen_sal) VALUES (59, 16, 4, NULL);
INSERT INTO centro_salud_pacientes (id_cen_sal_pac, id_his, id_cen_sal, otr_cen_sal) VALUES (60, 16, 9, NULL);
INSERT INTO centro_salud_pacientes (id_cen_sal_pac, id_his, id_cen_sal, otr_cen_sal) VALUES (61, 16, 7, NULL);
INSERT INTO centro_salud_pacientes (id_cen_sal_pac, id_his, id_cen_sal, otr_cen_sal) VALUES (20, 3, 5, NULL);


--
-- TOC entry 2293 (class 0 OID 17141)
-- Dependencies: 1674
-- Data for Name: centro_saluds; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (1, 'Hospital General', 'Hospital General');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (2, 'Hospital Universitario', 'Hospital Universitario');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (3, 'Hospital Especializado', 'Hospital Especializado');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (4, 'Ambulatorio Urbano', 'Ambulatorio Urbano');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (5, 'Ambulatorio Rural', 'Ambulatorio Rural');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (6, 'Instituto', 'Instituto');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (7, 'Clínica', 'Clínica');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (8, 'Dispensario', 'Dispensario');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (9, 'Barrio Adentro I', 'Barrio Adentro I');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (10, 'Barrio Adentro II', 'Barrio Adentro II');
INSERT INTO centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) VALUES (11, 'Barrio Adentro III', 'Barrio Adentro III');


--
-- TOC entry 2295 (class 0 OID 17161)
-- Dependencies: 1678
-- Data for Name: contactos_animales; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO contactos_animales (id_con_ani, id_his, id_ani, otr_ani) VALUES (30, 16, 4, NULL);
INSERT INTO contactos_animales (id_con_ani, id_his, id_ani, otr_ani) VALUES (31, 16, 3, NULL);
INSERT INTO contactos_animales (id_con_ani, id_his, id_ani, otr_ani) VALUES (32, 16, 2, NULL);
INSERT INTO contactos_animales (id_con_ani, id_his, id_ani, otr_ani) VALUES (33, 16, 1, NULL);


--
-- TOC entry 2296 (class 0 OID 17166)
-- Dependencies: 1680
-- Data for Name: doctores; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) VALUES (27, 'SAIB', 'SAIB', NULL, '83422503bcfc01d303030e8a7cc80efc', '3622824', NULL, 'SAIB', '2011-06-26 01:06:59.641-04:30');
INSERT INTO doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) VALUES (33, 'Mary', 'Lopez', '8752299', '9f4b04c2eac4a3cfa351aff1564f7995', '54564545646', 'mlopez@gmail.com', 'mlopez', '2011-06-26 01:06:59.641-04:30');
INSERT INTO doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) VALUES (28, 'Mireya', 'Gonzalez', '17302859', '3e46a122f1961a8ec71f2a369f6d16ee', '04265168824', NULL, 'mgonzalez', '2011-06-26 01:06:59.641-04:30');
INSERT INTO doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) VALUES (6, 'Luis', 'Marin', '17302857', '3e46a122f1961a8ec71f2a369f6d16ee', '3622222', 'ninja.aoshi@gmail.com', 'lmarin', '2011-06-26 01:06:59.641-04:30');
INSERT INTO doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) VALUES (34, 'Luis', 'Marin', '17302858', '3e46a122f1961a8ec71f2a369f6d16ee', '3622222', 'lrm.prigramador@gmail.com', 'lmarinn', '2011-07-08 15:58:52.908-04:30');
INSERT INTO doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) VALUES (32, 'Lisseth', 'Lozada', '17651233', '3e46a122f1961a8ec71f2a369f6d16ee', '04269150722', 'risusefu15@gmail.com', 'llozada', '2011-06-26 01:06:59.641-04:30');


--
-- TOC entry 2297 (class 0 OID 17174)
-- Dependencies: 1682
-- Data for Name: enfermedades_micologicas; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (1, 'Dermatofitosis', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (2, 'Onicomicosis dermatofitica', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (3, 'Onicomicosis no dermatofitica', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (4, 'Petitiriasis vericolor', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (5, 'Piedra blanca', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (6, 'Tiña negra', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (7, 'Oculomicosis', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (8, 'Otomicosis', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (9, 'Tinea capitis', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (10, 'Tinea barbae', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (11, 'Tinea corporis', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (12, 'Tinea cruris', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (13, 'Tinea imbricata', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (14, 'Tinea manuum', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (15, 'Tinea pedis', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (16, 'Tinea unguium', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (17, 'Cromomicosis dermatofitica', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (18, 'Otro', 1);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (19, 'Actinomicetoma', 2);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (20, 'Eumicetoma', 2);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (21, 'Esporotricosis', 2);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (22, 'Cromoblastomicosis', 2);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (23, 'Lobomicosis', 2);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (24, 'Coccidioidomicosis', 3);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (25, 'Histoplasmosis', 3);
INSERT INTO enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) VALUES (26, 'Paracoccidioidomicosis', 3);


--
-- TOC entry 2298 (class 0 OID 17179)
-- Dependencies: 1684
-- Data for Name: enfermedades_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (149, 1, NULL, NULL, 37);
INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (73, 1, NULL, NULL, NULL);
INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (74, 2, NULL, NULL, NULL);
INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (75, 1, NULL, NULL, NULL);
INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (76, 2, NULL, NULL, NULL);
INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (77, 1, NULL, NULL, NULL);
INSERT INTO enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) VALUES (78, 2, NULL, NULL, NULL);


--
-- TOC entry 2323 (class 0 OID 18420)
-- Dependencies: 1735
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO estados (id_est, des_est, id_pai) VALUES (1, 'Distrito Capital', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (2, 'Anzoátegui', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (3, 'Apure', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (4, 'Aragua', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (5, 'Barinas', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (6, 'Bolívar', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (7, 'Carabobo', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (8, 'Cojedes', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (9, 'Delta Amacuro', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (10, 'Falcón', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (11, 'Guárico', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (12, 'Lara', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (13, 'Mérida', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (14, 'Miranda', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (15, 'Monagas', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (16, 'Nueva Esparta', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (18, 'Portuguesa', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (19, 'Sucre', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (20, 'Táchira', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (21, 'Trujillo', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (22, 'Vargas', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (23, 'Yaracuy', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (24, 'Zulia', 1);
INSERT INTO estados (id_est, des_est, id_pai) VALUES (25, 'Amazonas', 1);


--
-- TOC entry 2299 (class 0 OID 17189)
-- Dependencies: 1686
-- Data for Name: forma_infecciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--



--
-- TOC entry 2300 (class 0 OID 17192)
-- Dependencies: 1687
-- Data for Name: forma_infecciones__pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--



--
-- TOC entry 2301 (class 0 OID 17197)
-- Dependencies: 1689
-- Data for Name: forma_infecciones__tipos_micosis; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--



--
-- TOC entry 2302 (class 0 OID 17204)
-- Dependencies: 1692
-- Data for Name: historiales_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO historiales_pacientes (id_his, id_pac, des_his, id_doc, des_adi_pac_his, fec_his) VALUES (3, 7, 'Nuevamente se inicia otra historia para hacer un seguimiento de rastros de una enfermedad de la piel', 6, 'El paciente por visualizacion padece de una coloracion en la piel.', '2011-07-01 10:24:00.188-04:30');
INSERT INTO historiales_pacientes (id_his, id_pac, des_his, id_doc, des_adi_pac_his, fec_his) VALUES (15, 13, 'demo', 6, '', '2011-07-13 14:01:14.823-04:30');
INSERT INTO historiales_pacientes (id_his, id_pac, des_his, id_doc, des_adi_pac_his, fec_his) VALUES (16, 7, 'demops', 6, 'demos', '2011-07-24 09:39:20.062-04:30');


--
-- TOC entry 2328 (class 0 OID 19087)
-- Dependencies: 1746
-- Data for Name: lesiones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO lesiones (id_les, nom_les) VALUES (1, 'Onicolisis subunguel distal');
INSERT INTO lesiones (id_les, nom_les) VALUES (2, 'Onicodistrofia total');
INSERT INTO lesiones (id_les, nom_les) VALUES (3, 'Coloracion blanco-amarillenta');
INSERT INTO lesiones (id_les, nom_les) VALUES (4, 'Coloración nugrezca');
INSERT INTO lesiones (id_les, nom_les) VALUES (5, 'Onicolisis subngeal proximal');
INSERT INTO lesiones (id_les, nom_les) VALUES (6, 'Leuconiquia');
INSERT INTO lesiones (id_les, nom_les) VALUES (7, 'Coloracion pardo-naranja');
INSERT INTO lesiones (id_les, nom_les) VALUES (8, 'Dermatofitoma');
INSERT INTO lesiones (id_les, nom_les) VALUES (9, 'Placas eritematoscomosa');
INSERT INTO lesiones (id_les, nom_les) VALUES (10, 'Descamativa');
INSERT INTO lesiones (id_les, nom_les) VALUES (11, 'Pruriginosa');
INSERT INTO lesiones (id_les, nom_les) VALUES (12, 'Bordes activos');
INSERT INTO lesiones (id_les, nom_les) VALUES (13, 'Inflamatoria');
INSERT INTO lesiones (id_les, nom_les) VALUES (14, 'Extensa');
INSERT INTO lesiones (id_les, nom_les) VALUES (15, 'Multiples');
INSERT INTO lesiones (id_les, nom_les) VALUES (16, 'Pustulas');
INSERT INTO lesiones (id_les, nom_les) VALUES (17, 'Alopecia');
INSERT INTO lesiones (id_les, nom_les) VALUES (18, 'Granuloma tricofitico');
INSERT INTO lesiones (id_les, nom_les) VALUES (19, 'Foliculitis');
INSERT INTO lesiones (id_les, nom_les) VALUES (20, 'Querion de celso');


--
-- TOC entry 2304 (class 0 OID 17214)
-- Dependencies: 1696
-- Data for Name: lesiones_partes_cuerpos__pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO lesiones_partes_cuerpos__pacientes (id_les_par_cue_pac, otr_les_par_cue, id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac) VALUES (156, NULL, 2, 1, 37);
INSERT INTO lesiones_partes_cuerpos__pacientes (id_les_par_cue_pac, otr_les_par_cue, id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac) VALUES (157, NULL, 3, 1, 37);
INSERT INTO lesiones_partes_cuerpos__pacientes (id_les_par_cue_pac, otr_les_par_cue, id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac) VALUES (158, NULL, 4, 1, 37);
INSERT INTO lesiones_partes_cuerpos__pacientes (id_les_par_cue_pac, otr_les_par_cue, id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac) VALUES (159, NULL, 2, 2, 37);
INSERT INTO lesiones_partes_cuerpos__pacientes (id_les_par_cue_pac, otr_les_par_cue, id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac) VALUES (160, NULL, 3, 2, 37);


--
-- TOC entry 2305 (class 0 OID 17219)
-- Dependencies: 1698
-- Data for Name: localizaciones_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--



--
-- TOC entry 2306 (class 0 OID 17229)
-- Dependencies: 1700
-- Data for Name: modulos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO modulos (id_mod, cod_mod, des_mod, id_tip_usu) VALUES (1, 'C', 'Configuración', 2);
INSERT INTO modulos (id_mod, cod_mod, des_mod, id_tip_usu) VALUES (2, 'R', 'Reportes', 2);


--
-- TOC entry 2307 (class 0 OID 17234)
-- Dependencies: 1702
-- Data for Name: muestras_clinicas; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (1, 'Pelo');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (2, 'Escama');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (3, 'Uñas');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (4, 'Exudado');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (5, 'Biopsia Piel');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (6, 'Biopsia Otros Órganos');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (7, 'Líquido Peritoneal');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (8, 'Líquido Sinovial');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (9, 'Líquido Cefalorraquídeo(LCR)');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (10, 'Líquido Pleural');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (11, 'Lavado Bronquial');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (12, 'Esputo Espontáneo');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (13, 'Esputo Inducido');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (14, 'Aspirado Traqueal');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (15, 'Cepillado Protegido');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (16, 'Punción Pulmonar');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (17, 'Punción Pleural');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (18, 'Médula Ósea');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (20, 'Exudado Vaginal');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (21, 'Orina');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (22, 'Heces');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (23, 'Cateterismo');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (24, 'Sondaje');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (25, 'Bolsa Colectora');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (26, 'Cavidad Oral');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (27, 'Exudado Nasal');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (28, 'Muestras Ópticas');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (29, 'Exudado Conjuntival');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (30, 'Raspado Corneal');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (31, 'Aspirado Ocular');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (32, 'Lentes de Contacto');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (33, 'Catéteres Intravasculares');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (34, 'Catéteres Diálisis Peritoneal');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (35, 'Prótesis');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (36, 'Otros');
INSERT INTO muestras_clinicas (id_mue_cli, nom_mue_cli) VALUES (19, 'Sangre');


--
-- TOC entry 2308 (class 0 OID 17239)
-- Dependencies: 1704
-- Data for Name: muestras_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO muestras_pacientes (id_mue_pac, id_his, id_mue_cli, otr_mue_cli) VALUES (17, 16, 1, NULL);


--
-- TOC entry 2324 (class 0 OID 18428)
-- Dependencies: 1737
-- Data for Name: municipios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (1, '	Libertador Caracas		 ', 1);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (2, '	Alto Orinoco		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (3, '	Atabapo		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (4, '	Atures		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (5, '	Autana		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (6, '	Manapiare		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (7, '	Maroa		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (8, '	Río Negro		 ', 25);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (9, '	Anaco		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (10, '	Aragua		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (11, '	Bolívar		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (12, '	Bruzual		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (13, '	Cajigal		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (14, '	Carvajal		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (15, '	Diego Bautista Urbaneja		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (16, '	Freites		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (17, '	Guanipa		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (18, '	Guanta		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (19, '	Independencia		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (20, '	Libertad		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (21, '	McGregor		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (22, '	Miranda		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (23, '	Monagas		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (24, '	Peñalver		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (25, '	Píritu		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (26, '	San Juan de Capistrano		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (27, '	Santa Ana		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (28, '	Simón Rodriguez		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (29, '	Sotillo		 ', 2);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (30, '	Achaguas		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (31, '	Biruaca		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (32, '	Muñoz		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (33, '	Páez		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (34, '	Pedro Camejo		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (35, '	Rómulo Gallegos		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (36, '	San Fernando		 ', 3);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (37, '	Bolívar		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (38, '	Camatagua		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (39, '	Francisco Linares Alcántara		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (40, '	Girardot		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (41, '	José Angel Lamas		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (42, '	José Félix Ribas		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (43, '	José Rafael Revenga		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (44, '	Libertador		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (45, '	Mario Briceño Iragorry		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (46, '	Ocumare de la Costa de Oro		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (47, '	San Casimiro		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (48, '	San Sebastián		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (49, '	Santiago Mariño		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (50, '	Santos Michelena		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (51, '	Sucre		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (52, '	Tovar		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (53, '	Urdaneta		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (54, '	Zamora		 ', 4);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (55, '	Alberto Arvelo Torrealba		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (56, '	Andrés Eloy Blanco		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (57, '	Antonio José de Sucre		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (58, '	Arismendi		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (59, '	Barinas		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (60, '	Bolívar		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (61, '	Cruz Paredes		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (62, '	Ezequiel Zamora		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (63, '	Obispos		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (64, '	Pedraza		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (65, '	Rojas		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (66, '	Sosa		 ', 5);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (67, '	Caroní		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (68, '	Cedeño		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (69, '	El Callao		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (70, '	Gran Sabana		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (71, '	Heres		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (72, '	Piar		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (73, '	Raúl Leoni		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (74, '	Roscio		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (75, '	Sifontes		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (76, '	Sucre		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (77, '	Padre Pedro Chien		 ', 6);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (78, '	Bejuma		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (79, '	Carlos Arvelo		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (80, '	Diego Ibarra		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (81, '	Guacara		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (82, '	Juan José Mora		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (83, '	Libertador		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (84, '	Los Guayos		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (85, '	Miranda		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (86, '	Montalbán		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (87, '	Naguanagua		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (88, '	Puerto Cabello		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (89, '	San Diego		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (90, '	San Joaquín		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (91, '	Valencia		 ', 7);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (92, '	Anzoátegui		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (93, '	Falcón		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (94, '	Girardot		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (95, '	Lima Blanco		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (96, '	Pao de San Juan Bautista		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (97, '	Ricaurte		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (98, '	Rómulo Gallegos		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (99, '	San Carlos		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (100, '	Tinaco		 ', 8);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (101, '	Antonio Díaz		 ', 9);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (102, '	Casacoima		 ', 9);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (103, '	Pedernales		 ', 9);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (104, '	Tucupita		 ', 9);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (105, '	Acosta		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (106, '	Bolívar		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (107, '	Buchivacoa		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (108, '	Cacique Manaure		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (109, '	Carirubana		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (110, '	Colina		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (111, '	Dabajuro		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (112, '	Democracia		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (113, '	Falcón		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (114, '	Federación		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (115, '	Jacura		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (116, '	Los Taques		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (117, '	Mauroa		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (118, '	Miranda		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (119, '	Monseñor Iturriza		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (120, '	Palmasola		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (121, '	Petit		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (122, '	Píritu		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (123, '	San Francisco		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (124, '	Silva		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (125, '	Sucre		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (126, '	Tocópero		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (127, '	Unión		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (128, '	Urumaco		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (129, '	Zamora		 ', 10);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (130, '	Camaguán		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (131, '	Chaguaramas		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (132, '	El Socorro		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (133, '	Sebastian Francisco de Miranda		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (134, '	José Félix Ribas		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (135, '	José Tadeo Monagas		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (136, '	Juan Germán Roscio		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (137, '	Julián Mellado		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (138, '	Las Mercedes		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (139, '	Leonardo Infante		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (140, '	Pedro Zaraza		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (141, '	Ortiz		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (142, '	San Gerónimo de Guayabal		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (143, '	San José de Guaribe		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (144, '	Santa María de Ipire		 ', 11);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (145, '	Andrés Eloy Blanco		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (146, '	Crespo		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (147, '	Iribarren		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (148, '	Jiménez		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (149, '	Morán		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (150, '	Palavecino		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (151, '	Simón Planas		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (152, '	Torres		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (153, '	Urdaneta		 ', 12);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (154, '	Alberto Adriani		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (155, '	Andrés Bello		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (156, '	Antonio Pinto Salinas		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (157, '	Aricagua		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (158, '	Arzobispo Chacón		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (159, '	Campo Elías		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (160, '	Caracciolo Parra Olmedo		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (161, '	Cardenal Quintero		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (162, '	Guaraque		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (163, '	Julio César Salas		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (164, '	Justo Briceño		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (165, '	Libertador		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (166, '	Miranda		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (167, '	Obispo Ramos de Lora		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (168, '	Padre Noguera		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (169, '	Pueblo Llano		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (170, '	Rangel		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (171, '	Rivas Dávila		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (172, '	Santos Marquina		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (173, '	Sucre		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (174, '	Tovar		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (175, '	Tulio Febres Cordero		 ', 13);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (176, '	Zea		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (177, '	Acevedo		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (178, '	Andrés Bello		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (179, '	Baruta		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (180, '	Brión		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (181, '	Buroz		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (182, '	Carrizal		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (183, '	Chacao		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (184, '	Cristóbal Rojas		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (185, '	El Hatillo		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (186, '	Guaicaipuro		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (187, '	Independencia		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (188, '	Lander		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (189, '	Los Salias		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (190, '	Páez		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (191, '	Paz Castillo		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (192, '	Pedro Gual		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (193, '	Plaza		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (194, '	Simón Bolívar		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (195, '	Sucre		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (196, '	Urdaneta		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (197, '	Zamora		 ', 14);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (198, '	Acosta		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (199, '	Aguasay		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (200, '	Bolívar		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (201, '	Caripe		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (202, '	Cedeño		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (203, '	Ezequiel Zamora		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (204, '	Libertador		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (205, '	Maturín		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (206, '	Piar		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (207, '	Punceres		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (208, '	Santa Bárbara		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (209, '	Sotillo		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (210, '	Uracoa		 ', 15);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (211, '	Antolín del Campo		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (212, '	Arismendi		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (213, '	Díaz		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (214, '	García		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (215, '	Gómez		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (216, '	Maneiro		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (217, '	Marcano		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (218, '	Mariño		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (219, '	Península de Macanao		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (220, '	Tubores		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (221, '	Villalba		 ', 16);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (222, '	Agua Blanca		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (223, '	Araure		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (224, '	Esteller		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (225, '	Guanare		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (226, '	Guanarito		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (227, '	Monseñor José Vicente de Unda		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (228, '	Ospino		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (229, '	Páez		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (230, '	Papelón		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (231, '	San Genaro de Boconoíto		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (232, '	San Rafael de Onoto		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (233, '	Santa Rosalía		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (234, '	Sucre		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (235, '	Turén		 ', 18);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (236, '	Andrés Eloy Blanco		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (237, '	Andrés Mata		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (238, '	Arismendi		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (239, '	Benítez		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (240, '	Bermúdez		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (241, '	Bolívar		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (242, '	Cajigal		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (243, '	Cruz Salmerón Acosta		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (244, '	Libertador		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (245, '	Mariño		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (246, '	Mejía		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (247, '	Montes		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (248, '	Ribero		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (249, '	Sucre		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (250, '	Valdez		 ', 19);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (251, '	Andrés Bello		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (252, '	Antonio Rómulo Costa		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (253, '	Ayacucho		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (254, '	Bolívar		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (255, '	Cárdenas		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (256, '	Córdoba		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (257, '	Fernández Feo		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (258, '	Francisco de Miranda		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (259, '	García de Hevia		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (260, '	Guásimos		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (261, '	Independencia		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (262, '	Jáuregui		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (263, '	José María Vargas		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (264, '	Junín		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (265, '	Libertad		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (266, '	Libertador		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (267, '	17. Lobatera		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (268, '	Michelena		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (269, '	Panamericano		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (270, '	Pedro María Ureña		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (271, '	Rafael Urdaneta		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (272, '	Samuel Darío Maldonado		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (273, '	San Cristóbal		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (274, '	Seboruco		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (275, '	Simón Rodríguez		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (276, '	Sucre		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (277, '	Torbes		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (278, '	Uribante		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (279, '	San Judas Tadeo		 ', 20);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (280, '	Andrés Bello		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (281, '	Boconó		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (282, '	Bolívar		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (283, '	Candelaria		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (284, '	Carache		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (285, '	Escuque		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (286, '	José Felipe Márquez Cañizalez		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (287, '	Juan Vicente Campos Elías		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (288, '	La Ceiba		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (289, '	Miranda		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (290, '	Monte Carmelo		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (291, '	Motatán		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (292, '	Pampán		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (293, '	Pampanito		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (294, '	Rafael Rangel		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (295, '	San Rafael de Carvajal		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (296, '	Sucre		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (297, '	Trujillo		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (298, '	Urdaneta		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (299, '	Valera		 ', 21);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (300, '	Vargas		 ', 22);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (301, '	Arístides Bastidas		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (302, '	Bolívar		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (303, '	Bruzual		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (304, '	Cocorote		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (305, '	Independencia		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (306, '	José Antonio Páez		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (307, '	La Trinidad		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (308, '	Manuel Monge		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (309, '	Nirgua		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (310, '	Peña		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (311, '	San Felipe		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (312, '	Sucre		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (313, '	Urachiche		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (314, '	Veroes		 ', 23);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (315, '	Almirante Padilla		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (316, '	Baralt		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (317, '	Cabimas		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (318, '	Catatumbo		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (319, '	Colón		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (320, '	Francisco Javier Pulgar		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (321, '	Guajira		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (322, '	Jesús Enrique Losada		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (323, '	Jesús María Semprún		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (324, '	La Cañada de Urdaneta		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (325, '	Lagunillas		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (326, '	Machiques de Perijá		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (327, '	Mara		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (328, '	Maracaibo		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (329, '	Miranda		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (330, '	Rosario de Perijá		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (331, '	San Francisco		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (332, '	Santa Rita		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (333, '	Simón Bolívar		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (334, '	Sucre		 ', 24);
INSERT INTO municipios (id_mun, des_mun, id_est) VALUES (335, '	Valmore Rodríguez		 ', 24);


--
-- TOC entry 2309 (class 0 OID 17244)
-- Dependencies: 1706
-- Data for Name: pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (7, 'Lozada', 'Adriana', '17651233', '2011-09-06', '1', '3622824', '04265168824', '2', 'Guarenas', 1, 1, 1, NULL, 1, 6, '2011-06-11 20:03:33.627-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (11, 'Hernandez', 'Jose', '17123098', '1976-08-21', '1', '02125682345', '04141235687', '1', 'Caracas', 1, 1, 1, NULL, 4, 27, '2011-06-11 20:03:33.627-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (12, 'Contreras', 'Gisela ', '13456094', '1970-09-25', '2', '00000', '00000', '4', 'Los Teques', 1, 1, 196, NULL, 5, 27, '2011-06-11 20:20:43.702-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (14, 'Wester', 'Mary', '8752299', '1965-05-02', '1', '02129874523', '042691587412', '6', 'Guarenas', 1, 1, 193, NULL, 7, 27, '2011-06-11 22:08:34.736-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (16, 'Paciente', 'Paciente', '17302857', '2011-07-09', '1', '3622824', '17302857', '1', 'Guarenas', 1, 1, 69, NULL, 6, 6, '2011-07-08 18:14:22.448-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (28, 'sdf', 'demo', '12345', '2011-07-27', '1', '3622222', '17302857', '2', 'Guarenas', 1, 1, 3, NULL, 8, 6, '2011-07-27 21:20:09.521-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (27, 'asd', 'demo', '1234', '2011-07-27', '1', '3622222', '173028555', '1', 'Guarenas', 1, 1, 1, NULL, 7, 6, '2011-07-27 21:12:19.655-04:30');
INSERT INTO pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac) VALUES (13, 'Beltran', 'Carlos', '7098456', '1961-05-02', '1', '0000', '0000', '4', 'Merida', 1, 1, 1, NULL, 6, 27, '2011-06-11 20:35:37.372-04:30');


--
-- TOC entry 2322 (class 0 OID 18412)
-- Dependencies: 1733
-- Data for Name: paises; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO paises (id_pai, des_pai, cod_pai) VALUES (1, 'Venezuela', 'VEN');


--
-- TOC entry 2325 (class 0 OID 18436)
-- Dependencies: 1739
-- Data for Name: parroquias; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--



--
-- TOC entry 2310 (class 0 OID 17252)
-- Dependencies: 1708
-- Data for Name: partes_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO partes_cuerpos (id_par_cue, nom_par_cue) VALUES (1, 'Pie');
INSERT INTO partes_cuerpos (id_par_cue, nom_par_cue) VALUES (2, 'Mano');


--
-- TOC entry 2329 (class 0 OID 19125)
-- Dependencies: 1748
-- Data for Name: partes_cuerpos__categorias_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO partes_cuerpos__categorias_cuerpos (id_par_cue_cat_cue, id_cat_cue, id_par_cue) VALUES (1, 1, 1);
INSERT INTO partes_cuerpos__categorias_cuerpos (id_par_cue_cat_cue, id_cat_cue, id_par_cue) VALUES (2, 1, 2);


--
-- TOC entry 2327 (class 0 OID 18883)
-- Dependencies: 1744
-- Data for Name: tiempo_evoluciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tiempo_evoluciones (id_tie_evo, id_his, tie_evo) VALUES (2, 3, 5);
INSERT INTO tiempo_evoluciones (id_tie_evo, id_his, tie_evo) VALUES (1, 16, 10);


--
-- TOC entry 2311 (class 0 OID 17262)
-- Dependencies: 1710
-- Data for Name: tipos_consultas; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (1, 'Consulta');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (2, 'Dermatologia');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (3, 'Pediatria');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (4, 'Neumologia');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (5, 'Consulta Interna');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (6, 'Geriatria');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (7, 'urologia');
INSERT INTO tipos_consultas (id_tip_con, nom_tip_con) VALUES (8, 'Infectologia');


--
-- TOC entry 2312 (class 0 OID 17267)
-- Dependencies: 1712
-- Data for Name: tipos_consultas_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_consultas_pacientes (id_tip_con_pac, id_tip_con, id_his, otr_tip_con) VALUES (61, 1, 16, NULL);
INSERT INTO tipos_consultas_pacientes (id_tip_con_pac, id_tip_con, id_his, otr_tip_con) VALUES (62, 5, 16, NULL);
INSERT INTO tipos_consultas_pacientes (id_tip_con_pac, id_tip_con, id_his, otr_tip_con) VALUES (63, 2, 16, NULL);


--
-- TOC entry 2313 (class 0 OID 17272)
-- Dependencies: 1714
-- Data for Name: tipos_estudios_micologicos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (1, 1, 'Hifas delgadas tabicadas', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (2, 1, 'Hifas gruesas tabicadas', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (3, 1, 'Blastoconidias', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (4, 1, 'Pseudohifas', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (5, 1, 'Artroconidias', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (6, 1, 'Hifas cortas y agrupamiento de esporas', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (7, 1, 'Esporas endotrix', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (8, 1, 'Esporas ectoendotrix', 1);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (9, 1, 'Microsporum canis', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (10, 1, 'Microsporum gypseum', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (11, 1, 'Microsporum nunum', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (12, 1, 'Truchophyton rubrum', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (13, 1, 'Trichophyton mentafrophytes', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (14, 1, 'Trichophyton tonsurans', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (15, 1, 'Trichophyton verrucosum', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (16, 1, 'Trichophyton violaceum', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (17, 1, 'Epidermophyton verrucosum', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (18, 1, 'Trichosporon', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (19, 1, 'Geotrichum spp', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (20, 1, 'Candita albicans', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (21, 1, 'Candida no Candida albicans', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (22, 1, 'Makassezia furfur', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (23, 1, 'Makassezia pachydermatis', 2);
INSERT INTO tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) VALUES (24, 1, 'Makassezia spp', 2);


--
-- TOC entry 2331 (class 0 OID 19279)
-- Dependencies: 1752
-- Data for Name: tipos_examenes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_examenes (id_tip_exa, nom_tip_exa) VALUES (1, 'Examen directo');
INSERT INTO tipos_examenes (id_tip_exa, nom_tip_exa) VALUES (2, 'Agente Aislado');


--
-- TOC entry 2314 (class 0 OID 17277)
-- Dependencies: 1716
-- Data for Name: tipos_micosis; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_micosis (id_tip_mic, nom_tip_mic) VALUES (1, 'Superficiales');
INSERT INTO tipos_micosis (id_tip_mic, nom_tip_mic) VALUES (2, 'Supcutaneas');
INSERT INTO tipos_micosis (id_tip_mic, nom_tip_mic) VALUES (3, 'Profundas');


--
-- TOC entry 2330 (class 0 OID 19170)
-- Dependencies: 1750
-- Data for Name: tipos_micosis_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_micosis_pacientes (id_tip_mic_pac, id_tip_mic, id_his) VALUES (37, 1, 16);


--
-- TOC entry 2332 (class 0 OID 19305)
-- Dependencies: 1754
-- Data for Name: tipos_micosis_pacientes__tipos_estudios_micologicos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) VALUES (16, 37, 1);
INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) VALUES (17, 37, 2);
INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) VALUES (18, 37, 3);
INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) VALUES (19, 37, 4);
INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) VALUES (20, 37, 5);
INSERT INTO tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) VALUES (21, 37, 6);


--
-- TOC entry 2315 (class 0 OID 17282)
-- Dependencies: 1718
-- Data for Name: tipos_usuarios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_usuarios (id_tip_usu, cod_tip_usu, des_tip_usu) VALUES (1, 'adm', 'Administrador');
INSERT INTO tipos_usuarios (id_tip_usu, cod_tip_usu, des_tip_usu) VALUES (2, 'med', 'Médicos');


--
-- TOC entry 2316 (class 0 OID 17285)
-- Dependencies: 1719
-- Data for Name: tipos_usuarios__usuarios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (17, 6, NULL, 2);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (36, NULL, 17, 1);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (41, NULL, 21, 1);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (43, 27, NULL, 2);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (44, 28, NULL, 2);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (45, NULL, 22, 1);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (49, 32, NULL, 2);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (50, 33, NULL, 2);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (51, 34, NULL, 2);
INSERT INTO tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) VALUES (52, NULL, 23, 1);


--
-- TOC entry 2317 (class 0 OID 17292)
-- Dependencies: 1722
-- Data for Name: transacciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (1, 'RED', 'Registrar enfermedades dermatologicas', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (2, 'MED', 'Modificar enfermedades dermatologicas', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (3, 'EED', 'Eliminar enfermedades dermatologicas', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (4, 'REF', 'Reportes de las estadisticas por enfermedad', 2);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (9, 'RP', 'Registrar Paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (10, 'MP', 'Modificar Paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (11, 'EP', 'Eliminar Paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (12, 'RHP', 'Registrar Historial de paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (13, 'MHP', 'Modificar Historial de paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (14, 'EHP', 'Modificar Historial de paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (15, 'MCP', 'Muestra Clínica del paciente', 1);
INSERT INTO transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) VALUES (16, 'IAP', 'Información Adicional del Paciente', 1);


--
-- TOC entry 2318 (class 0 OID 17297)
-- Dependencies: 1724
-- Data for Name: transacciones_usuarios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (1, 50, 86);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (2, 50, 87);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (3, 50, 88);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (1, 17, 93);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (2, 17, 94);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (3, 17, 95);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (4, 17, 96);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (1, 51, 105);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (2, 51, 106);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (3, 51, 107);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (4, 51, 108);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (1, 43, 48);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (2, 43, 49);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (3, 43, 50);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (4, 43, 51);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (1, 49, 113);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (2, 49, 114);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (3, 49, 115);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (4, 49, 116);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (1, 44, 64);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (2, 44, 65);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (3, 44, 66);
INSERT INTO transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) VALUES (4, 44, 67);


--
-- TOC entry 2319 (class 0 OID 17302)
-- Dependencies: 1725
-- Data for Name: tratamientos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tratamientos (id_tra, nom_tra) VALUES (1, 'Uso Antimicóticos');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (2, 'Uso Antibióticos');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (3, 'Tópicos');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (4, 'Sistémicos');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (5, 'Hormonas Sexuales');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (6, 'Glucorticoides');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (7, 'Citotóxicos');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (8, 'Radioterapia');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (9, 'Inmunosupresores');
INSERT INTO tratamientos (id_tra, nom_tra) VALUES (10, 'Otros');


--
-- TOC entry 2320 (class 0 OID 17307)
-- Dependencies: 1727
-- Data for Name: tratamientos_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (73, 16, 7, NULL);
INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (74, 16, 6, NULL);
INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (75, 16, 5, NULL);
INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (76, 16, 9, NULL);
INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (77, 16, 8, NULL);
INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (78, 16, 4, NULL);
INSERT INTO tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) VALUES (79, 16, 3, NULL);


--
-- TOC entry 2321 (class 0 OID 17312)
-- Dependencies: 1729
-- Data for Name: usuarios_administrativos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

INSERT INTO usuarios_administrativos (id_usu_adm, nom_usu_adm, ape_usu_adm, pas_usu_adm, log_usu_adm, tel_usu_adm, fec_reg_usu_adm, adm_usu) VALUES (17, 'SAIB', 'SAIB', 'fcc8c0a57ab902388613f2782eae3dd6', 'SAIB', '04162102903', '2011-06-04 14:24:44.315', true);
INSERT INTO usuarios_administrativos (id_usu_adm, nom_usu_adm, ape_usu_adm, pas_usu_adm, log_usu_adm, tel_usu_adm, fec_reg_usu_adm, adm_usu) VALUES (21, 'Luis', 'Marin', '3e46a122f1961a8ec71f2a369f6d16ee', 'lmarin', '04265168824', '2011-06-10 20:02:12.07', true);
INSERT INTO usuarios_administrativos (id_usu_adm, nom_usu_adm, ape_usu_adm, pas_usu_adm, log_usu_adm, tel_usu_adm, fec_reg_usu_adm, adm_usu) VALUES (23, 'lmarin', 'marin', '3e46a122f1961a8ec71f2a369f6d16ee', 'lmarin2', '36222222', '2011-07-08 16:10:19.402', true);
INSERT INTO usuarios_administrativos (id_usu_adm, nom_usu_adm, ape_usu_adm, pas_usu_adm, log_usu_adm, tel_usu_adm, fec_reg_usu_adm, adm_usu) VALUES (22, 'Lisseth', 'Lozada', '3e46a122f1961a8ec71f2a369f6d16ee', 'llozada', '04269150722', '2011-06-24 15:22:46.934', true);


SET default_tablespace = '';

--
-- TOC entry 2087 (class 2606 OID 17359)
-- Dependencies: 1662 1662
-- Name: animales_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY animales
    ADD CONSTRAINT animales_pkey PRIMARY KEY (id_ani);


--
-- TOC entry 2089 (class 2606 OID 17361)
-- Dependencies: 1664 1664
-- Name: antecedentes_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY antecedentes_pacientes
    ADD CONSTRAINT antecedentes_pacientes_pkey PRIMARY KEY (id_ant_pac);


--
-- TOC entry 2092 (class 2606 OID 17365)
-- Dependencies: 1666 1666
-- Name: antecedentes_personales_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY antecedentes_personales
    ADD CONSTRAINT antecedentes_personales_pkey PRIMARY KEY (id_ant_per);


SET default_tablespace = saib;

--
-- TOC entry 2094 (class 2606 OID 17367)
-- Dependencies: 1668 1668
-- Name: auditoria_transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

ALTER TABLE ONLY auditoria_transacciones
    ADD CONSTRAINT auditoria_transacciones_pkey PRIMARY KEY (id_aud_tra);


SET default_tablespace = '';

--
-- TOC entry 2097 (class 2606 OID 17369)
-- Dependencies: 1670 1670
-- Name: categorias__cuerpos_micosis_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_pkey PRIMARY KEY (id_cat_cue_mic);


--
-- TOC entry 2099 (class 2606 OID 17371)
-- Dependencies: 1670 1670 1670
-- Name: categorias__cuerpos_micosis_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_unique UNIQUE (id_cat_cue, id_tip_mic);


--
-- TOC entry 2102 (class 2606 OID 17377)
-- Dependencies: 1672 1672
-- Name: categorias_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias_cuerpos
    ADD CONSTRAINT categorias_cuerpos_pkey PRIMARY KEY (id_cat_cue);


--
-- TOC entry 2213 (class 2606 OID 18778)
-- Dependencies: 1741 1741
-- Name: centro_salud_doctores_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_pkey PRIMARY KEY (id_cen_sal_doc);


--
-- TOC entry 2215 (class 2606 OID 18780)
-- Dependencies: 1741 1741 1741
-- Name: centro_salud_doctores_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_unique UNIQUE (id_doc, id_cen_sal);


--
-- TOC entry 2108 (class 2606 OID 17379)
-- Dependencies: 1676 1676
-- Name: centro_salud_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_pkey PRIMARY KEY (id_cen_sal_pac);


--
-- TOC entry 2110 (class 2606 OID 17381)
-- Dependencies: 1676 1676 1676
-- Name: centro_salud_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_unique UNIQUE (id_his, id_cen_sal);


--
-- TOC entry 2105 (class 2606 OID 17383)
-- Dependencies: 1674 1674
-- Name: centro_salud_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_saluds
    ADD CONSTRAINT centro_salud_pkey PRIMARY KEY (id_cen_sal);


--
-- TOC entry 2113 (class 2606 OID 17389)
-- Dependencies: 1678 1678
-- Name: contactos_animales_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_pkey PRIMARY KEY (id_con_ani);


--
-- TOC entry 2115 (class 2606 OID 17391)
-- Dependencies: 1678 1678 1678
-- Name: contactos_animales_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_unique UNIQUE (id_his, id_ani);


--
-- TOC entry 2117 (class 2606 OID 17393)
-- Dependencies: 1680 1680
-- Name: doctores_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY doctores
    ADD CONSTRAINT doctores_pkey PRIMARY KEY (id_doc);


--
-- TOC entry 2120 (class 2606 OID 17395)
-- Dependencies: 1682 1682
-- Name: enfermedades_micologicas_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY enfermedades_micologicas
    ADD CONSTRAINT enfermedades_micologicas_pkey PRIMARY KEY (id_enf_mic);


--
-- TOC entry 2122 (class 2606 OID 17397)
-- Dependencies: 1684 1684
-- Name: enfermedades_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_pkey PRIMARY KEY (id_enf_pac);


--
-- TOC entry 2206 (class 2606 OID 18425)
-- Dependencies: 1735 1735
-- Name: estados_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (id_est);


--
-- TOC entry 2128 (class 2606 OID 17405)
-- Dependencies: 1687 1687
-- Name: forma_infecciones__pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_pkey PRIMARY KEY (id_for_pac);


--
-- TOC entry 2131 (class 2606 OID 17409)
-- Dependencies: 1689 1689
-- Name: forma_infecciones__tipos_micosis_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_pkey PRIMARY KEY (id_for_inf_tip_mic);


--
-- TOC entry 2133 (class 2606 OID 17411)
-- Dependencies: 1689 1689 1689
-- Name: forma_infecciones__tipos_micosis_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_unique UNIQUE (id_tip_mic, id_for_inf);


--
-- TOC entry 2125 (class 2606 OID 17413)
-- Dependencies: 1686 1686
-- Name: forma_infecciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones
    ADD CONSTRAINT forma_infecciones_pkey PRIMARY KEY (id_for_inf);


--
-- TOC entry 2136 (class 2606 OID 17415)
-- Dependencies: 1692 1692
-- Name: historiales_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY historiales_pacientes
    ADD CONSTRAINT historiales_pacientes_pkey PRIMARY KEY (id_his);


--
-- TOC entry 2139 (class 2606 OID 17417)
-- Dependencies: 1694 1694
-- Name: lesiones__partes_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT lesiones__partes_cuerpos_pkey PRIMARY KEY (id_cat_cue_les);


--
-- TOC entry 2219 (class 2606 OID 19092)
-- Dependencies: 1746 1746
-- Name: lesiones_id_les_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY lesiones
    ADD CONSTRAINT lesiones_id_les_pkey PRIMARY KEY (id_les);


--
-- TOC entry 2142 (class 2606 OID 17419)
-- Dependencies: 1696 1696
-- Name: lesiones_partes_cuerpos__pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_pkey PRIMARY KEY (id_les_par_cue_pac);


--
-- TOC entry 2145 (class 2606 OID 17423)
-- Dependencies: 1698 1698
-- Name: localizaciones_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY localizaciones_cuerpos
    ADD CONSTRAINT localizaciones_cuerpos_pkey PRIMARY KEY (id_loc_cue);


--
-- TOC entry 2147 (class 2606 OID 17849)
-- Dependencies: 1700 1700 1700
-- Name: modulos_cod_mod_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_cod_mod_unique UNIQUE (cod_mod, id_tip_usu);


--
-- TOC entry 2149 (class 2606 OID 17427)
-- Dependencies: 1700 1700
-- Name: modulos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_pkey PRIMARY KEY (id_mod);


--
-- TOC entry 2152 (class 2606 OID 17429)
-- Dependencies: 1702 1702
-- Name: muestras_clinicas_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY muestras_clinicas
    ADD CONSTRAINT muestras_clinicas_pkey PRIMARY KEY (id_mue_cli);


--
-- TOC entry 2154 (class 2606 OID 17431)
-- Dependencies: 1704 1704
-- Name: muestras_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_pkey PRIMARY KEY (id_mue_pac);


--
-- TOC entry 2156 (class 2606 OID 17433)
-- Dependencies: 1704 1704 1704
-- Name: muestras_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_unique UNIQUE (id_his, id_mue_cli);


--
-- TOC entry 2208 (class 2606 OID 18433)
-- Dependencies: 1737 1737
-- Name: municipios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY municipios
    ADD CONSTRAINT municipios_pkey PRIMARY KEY (id_mun);


--
-- TOC entry 2159 (class 2606 OID 17435)
-- Dependencies: 1706 1706
-- Name: pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_pkey PRIMARY KEY (id_pac);


--
-- TOC entry 2204 (class 2606 OID 18417)
-- Dependencies: 1733 1733
-- Name: paises_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (id_pai);


--
-- TOC entry 2210 (class 2606 OID 18441)
-- Dependencies: 1739 1739
-- Name: parroquias_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY parroquias
    ADD CONSTRAINT parroquias_pkey PRIMARY KEY (id_par);


--
-- TOC entry 2221 (class 2606 OID 19130)
-- Dependencies: 1748 1748
-- Name: partes_cuerpos__categorias_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_pkey PRIMARY KEY (id_par_cue_cat_cue);


--
-- TOC entry 2223 (class 2606 OID 19132)
-- Dependencies: 1748 1748 1748
-- Name: partes_cuerpos__categorias_cuerpos_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_unique UNIQUE (id_cat_cue, id_par_cue);


--
-- TOC entry 2162 (class 2606 OID 17437)
-- Dependencies: 1708 1708
-- Name: partes_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY partes_cuerpos
    ADD CONSTRAINT partes_cuerpos_pkey PRIMARY KEY (id_par_cue);


--
-- TOC entry 2217 (class 2606 OID 18906)
-- Dependencies: 1744 1744
-- Name: tiempo_evoluciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tiempo_evoluciones
    ADD CONSTRAINT tiempo_evoluciones_pkey PRIMARY KEY (id_tie_evo);


--
-- TOC entry 2168 (class 2606 OID 17441)
-- Dependencies: 1712 1712
-- Name: tipos_consultas_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_pkey PRIMARY KEY (id_tip_con_pac);


--
-- TOC entry 2170 (class 2606 OID 17443)
-- Dependencies: 1712 1712 1712
-- Name: tipos_consultas_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_unique UNIQUE (id_tip_con, id_his);


--
-- TOC entry 2165 (class 2606 OID 17445)
-- Dependencies: 1710 1710
-- Name: tipos_consultas_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_consultas
    ADD CONSTRAINT tipos_consultas_pkey PRIMARY KEY (id_tip_con);


--
-- TOC entry 2173 (class 2606 OID 17447)
-- Dependencies: 1714 1714
-- Name: tipos_estudios_micologicos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_estudios_micologicos
    ADD CONSTRAINT tipos_estudios_micologicos_pkey PRIMARY KEY (id_tip_est_mic);


--
-- TOC entry 2227 (class 2606 OID 19284)
-- Dependencies: 1752 1752
-- Name: tipos_examenes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_examenes
    ADD CONSTRAINT tipos_examenes_pkey PRIMARY KEY (id_tip_exa);


--
-- TOC entry 2229 (class 2606 OID 19310)
-- Dependencies: 1754 1754
-- Name: tipos_micosis_pacientes__tipos_estudios_micologicos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_micologicos_pkey PRIMARY KEY (id_tip_mic_pac_tip_est_mic);


--
-- TOC entry 2225 (class 2606 OID 19175)
-- Dependencies: 1750 1750
-- Name: tipos_micosis_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_pkey PRIMARY KEY (id_tip_mic_pac);


--
-- TOC entry 2176 (class 2606 OID 17449)
-- Dependencies: 1716 1716
-- Name: tipos_micosis_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis
    ADD CONSTRAINT tipos_micosis_pkey PRIMARY KEY (id_tip_mic);


--
-- TOC entry 2182 (class 2606 OID 17451)
-- Dependencies: 1719 1719
-- Name: tipos_usuarios__usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_pkey PRIMARY KEY (id_tip_usu_usu);


--
-- TOC entry 2178 (class 2606 OID 17453)
-- Dependencies: 1718 1718
-- Name: tipos_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_usuarios
    ADD CONSTRAINT tipos_usuarios_pkey PRIMARY KEY (id_tip_usu);


SET default_tablespace = saib;

--
-- TOC entry 2180 (class 2606 OID 17744)
-- Dependencies: 1718 1718
-- Name: tipos_usuarios_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

ALTER TABLE ONLY tipos_usuarios
    ADD CONSTRAINT tipos_usuarios_unique UNIQUE (cod_tip_usu);


SET default_tablespace = '';

--
-- TOC entry 2186 (class 2606 OID 17818)
-- Dependencies: 1722 1722 1722
-- Name: transacciones_cod_tip_tra__id_mod; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY transacciones
    ADD CONSTRAINT transacciones_cod_tip_tra__id_mod UNIQUE (id_mod, cod_tip_tra);


--
-- TOC entry 2188 (class 2606 OID 17455)
-- Dependencies: 1722 1722
-- Name: transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY transacciones
    ADD CONSTRAINT transacciones_pkey PRIMARY KEY (id_tip_tra);


--
-- TOC entry 2190 (class 2606 OID 18032)
-- Dependencies: 1724 1724
-- Name: transacciones_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY transacciones_usuarios
    ADD CONSTRAINT transacciones_usuarios_pkey PRIMARY KEY (id_tra_usu);


--
-- TOC entry 2196 (class 2606 OID 17459)
-- Dependencies: 1727 1727
-- Name: tratamientos_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_pkey PRIMARY KEY (id_tra_pac);


--
-- TOC entry 2198 (class 2606 OID 17461)
-- Dependencies: 1727 1727 1727
-- Name: tratamientos_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_unique UNIQUE (id_his, id_tra);


--
-- TOC entry 2193 (class 2606 OID 17463)
-- Dependencies: 1725 1725
-- Name: tratamientos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tratamientos
    ADD CONSTRAINT tratamientos_pkey PRIMARY KEY (id_tra);


--
-- TOC entry 2184 (class 2606 OID 17469)
-- Dependencies: 1719 1719 1719 1719
-- Name: unique_tipos_usuarios__usuarios; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT unique_tipos_usuarios__usuarios UNIQUE (id_doc, id_usu_adm, id_tip_usu);


--
-- TOC entry 2200 (class 2606 OID 17892)
-- Dependencies: 1729 1729
-- Name: usuarios_administrativos_log_usu_adm_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY usuarios_administrativos
    ADD CONSTRAINT usuarios_administrativos_log_usu_adm_unique UNIQUE (log_usu_adm);


SET default_tablespace = saib;

--
-- TOC entry 2202 (class 2606 OID 17473)
-- Dependencies: 1729 1729
-- Name: usuarios_administrativos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

ALTER TABLE ONLY usuarios_administrativos
    ADD CONSTRAINT usuarios_administrativos_pkey PRIMARY KEY (id_usu_adm);


--
-- TOC entry 2085 (class 1259 OID 17474)
-- Dependencies: 1662
-- Name: animales_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX animales_index ON animales USING btree (id_ani);


--
-- TOC entry 2090 (class 1259 OID 17476)
-- Dependencies: 1666
-- Name: antecedentes_personales_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX antecedentes_personales_index ON antecedentes_personales USING btree (id_ant_per);


--
-- TOC entry 2095 (class 1259 OID 17477)
-- Dependencies: 1670
-- Name: categorias__cuerpos_micosis_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX categorias__cuerpos_micosis_index ON categorias__cuerpos_micosis USING btree (id_cat_cue_mic);


--
-- TOC entry 2100 (class 1259 OID 17478)
-- Dependencies: 1672
-- Name: categorias_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX categorias_cuerpos_index ON categorias_cuerpos USING btree (id_cat_cue);


SET default_tablespace = '';

--
-- TOC entry 2211 (class 1259 OID 18791)
-- Dependencies: 1741 1741 1741
-- Name: centro_salud_doctores_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE INDEX centro_salud_doctores_index ON centro_salud_doctores USING btree (id_cen_sal_doc, id_doc, id_cen_sal);


SET default_tablespace = saib;

--
-- TOC entry 2103 (class 1259 OID 17479)
-- Dependencies: 1674
-- Name: centro_salud_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX centro_salud_index ON centro_saluds USING btree (id_cen_sal);


--
-- TOC entry 2106 (class 1259 OID 17480)
-- Dependencies: 1676 1676 1676
-- Name: centro_salud_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX centro_salud_pacientes_index ON centro_salud_pacientes USING btree (id_cen_sal_pac, id_his, id_cen_sal);


--
-- TOC entry 2111 (class 1259 OID 17481)
-- Dependencies: 1678 1678 1678
-- Name: contactos_animales_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX contactos_animales_index ON contactos_animales USING btree (id_con_ani, id_his, id_ani);


--
-- TOC entry 2118 (class 1259 OID 17482)
-- Dependencies: 1682
-- Name: enfermedades_micologicas_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX enfermedades_micologicas_index ON enfermedades_micologicas USING btree (id_enf_mic);


--
-- TOC entry 2126 (class 1259 OID 17485)
-- Dependencies: 1687
-- Name: forma_infecciones__pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX forma_infecciones__pacientes_index ON forma_infecciones__pacientes USING btree (id_for_pac);


--
-- TOC entry 2129 (class 1259 OID 17486)
-- Dependencies: 1689
-- Name: forma_infecciones__tipos_micosis_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX forma_infecciones__tipos_micosis_index ON forma_infecciones__tipos_micosis USING btree (id_for_inf_tip_mic);


--
-- TOC entry 2123 (class 1259 OID 17487)
-- Dependencies: 1686
-- Name: forma_infecciones_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX forma_infecciones_index ON forma_infecciones USING btree (id_for_inf);


--
-- TOC entry 2134 (class 1259 OID 17488)
-- Dependencies: 1692
-- Name: historiales_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX historiales_pacientes_index ON historiales_pacientes USING btree (id_his);


--
-- TOC entry 2137 (class 1259 OID 17490)
-- Dependencies: 1694
-- Name: lesiones__partes_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX lesiones__partes_cuerpos_index ON categorias_cuerpos__lesiones USING btree (id_cat_cue_les);


--
-- TOC entry 2140 (class 1259 OID 17491)
-- Dependencies: 1696
-- Name: lesiones_partes_cuerpos__pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX lesiones_partes_cuerpos__pacientes_index ON lesiones_partes_cuerpos__pacientes USING btree (id_les_par_cue_pac);


--
-- TOC entry 2143 (class 1259 OID 17492)
-- Dependencies: 1698
-- Name: localizaciones_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX localizaciones_cuerpos_index ON localizaciones_cuerpos USING btree (id_loc_cue);


--
-- TOC entry 2150 (class 1259 OID 17493)
-- Dependencies: 1702
-- Name: muestras_clinicas_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX muestras_clinicas_index ON muestras_clinicas USING btree (id_mue_cli);


--
-- TOC entry 2157 (class 1259 OID 17494)
-- Dependencies: 1706
-- Name: pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX pacientes_index ON pacientes USING btree (id_pac);


--
-- TOC entry 2160 (class 1259 OID 17495)
-- Dependencies: 1708
-- Name: partes_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX partes_cuerpos_index ON partes_cuerpos USING btree (id_par_cue);


--
-- TOC entry 2163 (class 1259 OID 17497)
-- Dependencies: 1710
-- Name: tipos_consultas_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_consultas_index ON tipos_consultas USING btree (id_tip_con);


--
-- TOC entry 2166 (class 1259 OID 17498)
-- Dependencies: 1712 1712 1712
-- Name: tipos_consultas_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_consultas_pacientes_index ON tipos_consultas_pacientes USING btree (id_tip_con_pac, id_tip_con, id_his);


--
-- TOC entry 2171 (class 1259 OID 17499)
-- Dependencies: 1714
-- Name: tipos_estudios_micologicos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_estudios_micologicos_index ON tipos_estudios_micologicos USING btree (id_tip_est_mic);


--
-- TOC entry 2174 (class 1259 OID 17500)
-- Dependencies: 1716
-- Name: tipos_micosis_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_micosis_index ON tipos_micosis USING btree (id_tip_mic);


--
-- TOC entry 2191 (class 1259 OID 17501)
-- Dependencies: 1725
-- Name: tratamientos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tratamientos_index ON tratamientos USING btree (id_tra);


--
-- TOC entry 2194 (class 1259 OID 17502)
-- Dependencies: 1727 1727 1727
-- Name: tratamientos_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tratamientos_pacientes_index ON tratamientos_pacientes USING btree (id_tra_pac, id_his, id_tra);


--
-- TOC entry 2231 (class 2606 OID 17503)
-- Dependencies: 1664 1666 2091
-- Name: antecedentes_pacientes_id_ant_per_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY antecedentes_pacientes
    ADD CONSTRAINT antecedentes_pacientes_id_ant_per_fkey FOREIGN KEY (id_ant_per) REFERENCES antecedentes_personales(id_ant_per) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2230 (class 2606 OID 18893)
-- Dependencies: 2158 1664 1706
-- Name: antecedentes_pacientes_id_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY antecedentes_pacientes
    ADD CONSTRAINT antecedentes_pacientes_id_pac_fkey FOREIGN KEY (id_pac) REFERENCES pacientes(id_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2232 (class 2606 OID 17790)
-- Dependencies: 2187 1722 1668
-- Name: auditoria_transacciones_id_tip_tra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY auditoria_transacciones
    ADD CONSTRAINT auditoria_transacciones_id_tip_tra_fkey FOREIGN KEY (id_tip_tra) REFERENCES transacciones(id_tip_tra) ON UPDATE CASCADE;


--
-- TOC entry 2233 (class 2606 OID 17795)
-- Dependencies: 1668 2181 1719
-- Name: auditoria_transacciones_id_tip_usu_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY auditoria_transacciones
    ADD CONSTRAINT auditoria_transacciones_id_tip_usu_usu_fkey FOREIGN KEY (id_tip_usu_usu) REFERENCES tipos_usuarios__usuarios(id_tip_usu_usu) ON UPDATE CASCADE;


--
-- TOC entry 2249 (class 2606 OID 19118)
-- Dependencies: 1672 2101 1694
-- Name: categoria_cuerpos__partes_cuerpos_id_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT categoria_cuerpos__partes_cuerpos_id_cat_cue_fkey FOREIGN KEY (id_cat_cue) REFERENCES categorias_cuerpos(id_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2234 (class 2606 OID 17528)
-- Dependencies: 1670 1672 2101
-- Name: categorias__cuerpos_micosis_id_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_id_cat_cue_fkey FOREIGN KEY (id_cat_cue) REFERENCES categorias_cuerpos(id_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2235 (class 2606 OID 17533)
-- Dependencies: 2175 1670 1716
-- Name: categorias__cuerpos_micosis_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2278 (class 2606 OID 18781)
-- Dependencies: 2104 1674 1741
-- Name: centro_salud_doctores_id_cen_sal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_id_cen_sal_fkey FOREIGN KEY (id_cen_sal) REFERENCES centro_saluds(id_cen_sal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2279 (class 2606 OID 18786)
-- Dependencies: 1680 2116 1741
-- Name: centro_salud_doctores_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2236 (class 2606 OID 17548)
-- Dependencies: 2104 1674 1676
-- Name: centro_salud_pacientes_id_cen_sal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_id_cen_sal_fkey FOREIGN KEY (id_cen_sal) REFERENCES centro_saluds(id_cen_sal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2237 (class 2606 OID 17553)
-- Dependencies: 2135 1676 1692
-- Name: centro_salud_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2238 (class 2606 OID 17568)
-- Dependencies: 1678 1662 2086
-- Name: contactos_animales_id_ani_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_id_ani_fkey FOREIGN KEY (id_ani) REFERENCES animales(id_ani) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2239 (class 2606 OID 17573)
-- Dependencies: 1678 2135 1692
-- Name: contactos_animales_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2240 (class 2606 OID 17583)
-- Dependencies: 2175 1682 1716
-- Name: enfermedades_micologicas_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY enfermedades_micologicas
    ADD CONSTRAINT enfermedades_micologicas_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2242 (class 2606 OID 17588)
-- Dependencies: 1684 2119 1682
-- Name: enfermedades_pacientes_id_enf_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_id_enf_mic_fkey FOREIGN KEY (id_enf_mic) REFERENCES enfermedades_micologicas(id_enf_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2241 (class 2606 OID 19194)
-- Dependencies: 1684 2224 1750
-- Name: enfermedades_pacientes_id_tip_enf_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_id_tip_enf_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2275 (class 2606 OID 18462)
-- Dependencies: 1735 1733 2203
-- Name: estados_id_pai_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_id_pai_fkey FOREIGN KEY (id_pai) REFERENCES paises(id_pai) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2244 (class 2606 OID 17608)
-- Dependencies: 2124 1687 1686
-- Name: forma_infecciones__pacientes_id_for_inf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_id_for_inf_fkey FOREIGN KEY (id_for_inf) REFERENCES forma_infecciones(id_for_inf) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2243 (class 2606 OID 19326)
-- Dependencies: 1750 1687 2224
-- Name: forma_infecciones__pacientes_id_tip_mic_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_id_tip_mic_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2245 (class 2606 OID 17618)
-- Dependencies: 2124 1689 1686
-- Name: forma_infecciones__tipos_micosis_id_for_inf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_id_for_inf_fkey FOREIGN KEY (id_for_inf) REFERENCES forma_infecciones(id_for_inf) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2246 (class 2606 OID 17623)
-- Dependencies: 2175 1716 1689
-- Name: forma_infecciones__tipos_micosis_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2248 (class 2606 OID 18795)
-- Dependencies: 1680 2116 1692
-- Name: historiales_pacientes_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY historiales_pacientes
    ADD CONSTRAINT historiales_pacientes_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2247 (class 2606 OID 17628)
-- Dependencies: 1692 2158 1706
-- Name: historiales_pacientes_id_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY historiales_pacientes
    ADD CONSTRAINT historiales_pacientes_id_pac_fkey FOREIGN KEY (id_pac) REFERENCES pacientes(id_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2250 (class 2606 OID 19098)
-- Dependencies: 1746 1694 2218
-- Name: lesiones__partes_cuerpos_id_les_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT lesiones__partes_cuerpos_id_les_fkey FOREIGN KEY (id_les) REFERENCES lesiones(id_les) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2251 (class 2606 OID 19209)
-- Dependencies: 1694 2138 1696
-- Name: lesiones_partes_cuerpos__pacientes_id_cat_cue_les_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_id_cat_cue_les_fkey FOREIGN KEY (id_cat_cue_les) REFERENCES categorias_cuerpos__lesiones(id_cat_cue_les) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2252 (class 2606 OID 19214)
-- Dependencies: 1748 1696 2220
-- Name: lesiones_partes_cuerpos__pacientes_id_par_cue_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_id_par_cue_cat_cue_fkey FOREIGN KEY (id_par_cue_cat_cue) REFERENCES partes_cuerpos__categorias_cuerpos(id_par_cue_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2253 (class 2606 OID 19219)
-- Dependencies: 2224 1696 1750
-- Name: lesiones_partes_cuerpos__pacientes_id_tip_mic_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_id_tip_mic_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2254 (class 2606 OID 19075)
-- Dependencies: 2161 1708 1698
-- Name: localizaciones_cuerpos_id_par_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY localizaciones_cuerpos
    ADD CONSTRAINT localizaciones_cuerpos_id_par_cue_fkey FOREIGN KEY (id_par_cue) REFERENCES partes_cuerpos(id_par_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2255 (class 2606 OID 17982)
-- Dependencies: 1718 1700 2177
-- Name: modulos_id_tip_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_id_tip_usu_fkey FOREIGN KEY (id_tip_usu) REFERENCES tipos_usuarios(id_tip_usu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2256 (class 2606 OID 17658)
-- Dependencies: 1692 2135 1704
-- Name: muestras_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2257 (class 2606 OID 17663)
-- Dependencies: 2151 1702 1704
-- Name: muestras_pacientes_id_mue_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_id_mue_cli_fkey FOREIGN KEY (id_mue_cli) REFERENCES muestras_clinicas(id_mue_cli) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2276 (class 2606 OID 18467)
-- Dependencies: 2205 1735 1737
-- Name: municipios_id_est_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY municipios
    ADD CONSTRAINT municipios_id_est_fkey FOREIGN KEY (id_est) REFERENCES estados(id_est) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2262 (class 2606 OID 18646)
-- Dependencies: 1680 2116 1706
-- Name: pacientes_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2258 (class 2606 OID 18498)
-- Dependencies: 1735 1706 2205
-- Name: pacientes_id_est_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_est_fkey FOREIGN KEY (id_est) REFERENCES estados(id_est) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2259 (class 2606 OID 18503)
-- Dependencies: 1706 2207 1737
-- Name: pacientes_id_mun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_mun_fkey FOREIGN KEY (id_mun) REFERENCES municipios(id_mun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2261 (class 2606 OID 18513)
-- Dependencies: 2203 1706 1733
-- Name: pacientes_id_pai_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_pai_fkey FOREIGN KEY (id_pai) REFERENCES paises(id_pai) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2260 (class 2606 OID 18508)
-- Dependencies: 1739 2209 1706
-- Name: pacientes_id_par_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_par_fkey FOREIGN KEY (id_par) REFERENCES parroquias(id_par) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2277 (class 2606 OID 18472)
-- Dependencies: 1739 2207 1737
-- Name: parroquias_id_mun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY parroquias
    ADD CONSTRAINT parroquias_id_mun_fkey FOREIGN KEY (id_mun) REFERENCES municipios(id_mun) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2281 (class 2606 OID 19133)
-- Dependencies: 2101 1748 1672
-- Name: partes_cuerpos__categorias_cuerpos_id_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_id_cat_cue_fkey FOREIGN KEY (id_cat_cue) REFERENCES categorias_cuerpos(id_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2282 (class 2606 OID 19138)
-- Dependencies: 2161 1748 1708
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_id_par_cue_fkey FOREIGN KEY (id_par_cue) REFERENCES partes_cuerpos(id_par_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2280 (class 2606 OID 18888)
-- Dependencies: 1744 2135 1692
-- Name: tiempo_evoluciones_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tiempo_evoluciones
    ADD CONSTRAINT tiempo_evoluciones_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2263 (class 2606 OID 17678)
-- Dependencies: 2135 1692 1712
-- Name: tipos_consultas_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2264 (class 2606 OID 17683)
-- Dependencies: 1710 2164 1712
-- Name: tipos_consultas_pacientes_id_tip_con_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_id_tip_con_fkey FOREIGN KEY (id_tip_con) REFERENCES tipos_consultas(id_tip_con) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2266 (class 2606 OID 19285)
-- Dependencies: 1714 2226 1752
-- Name: tipos_estudios_micologicos_id_tip_exa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_estudios_micologicos
    ADD CONSTRAINT tipos_estudios_micologicos_id_tip_exa_fkey FOREIGN KEY (id_tip_exa) REFERENCES tipos_examenes(id_tip_exa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2265 (class 2606 OID 17688)
-- Dependencies: 1716 1714 2175
-- Name: tipos_estudios_micologicos_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_estudios_micologicos
    ADD CONSTRAINT tipos_estudios_micologicos_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2286 (class 2606 OID 19316)
-- Dependencies: 1714 1754 2172
-- Name: tipos_micosis_pacientes__tipos_estudios_mic_id_tip_est_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_mic_id_tip_est_mic_fkey FOREIGN KEY (id_tip_est_mic) REFERENCES tipos_estudios_micologicos(id_tip_est_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2285 (class 2606 OID 19311)
-- Dependencies: 1750 2224 1754
-- Name: tipos_micosis_pacientes__tipos_estudios_mic_id_tip_mic_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_mic_id_tip_mic_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2284 (class 2606 OID 19181)
-- Dependencies: 2135 1750 1692
-- Name: tipos_micosis_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2283 (class 2606 OID 19176)
-- Dependencies: 2175 1716 1750
-- Name: tipos_micosis_pacientes_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2269 (class 2606 OID 17997)
-- Dependencies: 1680 1719 2116
-- Name: tipos_usuarios__usuarios_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2267 (class 2606 OID 17765)
-- Dependencies: 2177 1719 1718
-- Name: tipos_usuarios__usuarios_id_tip_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_id_tip_usu_fkey FOREIGN KEY (id_tip_usu) REFERENCES tipos_usuarios(id_tip_usu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2268 (class 2606 OID 17907)
-- Dependencies: 2201 1719 1729
-- Name: tipos_usuarios__usuarios_id_usu_adm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_id_usu_adm_fkey FOREIGN KEY (id_usu_adm) REFERENCES usuarios_administrativos(id_usu_adm) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2270 (class 2606 OID 17805)
-- Dependencies: 1722 2148 1700
-- Name: transacciones_id_mod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY transacciones
    ADD CONSTRAINT transacciones_id_mod_fkey FOREIGN KEY (id_mod) REFERENCES modulos(id_mod) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2272 (class 2606 OID 18023)
-- Dependencies: 1722 1724 2187
-- Name: transacciones_usuarios_id_tip_tra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY transacciones_usuarios
    ADD CONSTRAINT transacciones_usuarios_id_tip_tra_fkey FOREIGN KEY (id_tip_tra) REFERENCES transacciones(id_tip_tra) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2271 (class 2606 OID 18013)
-- Dependencies: 2181 1724 1719
-- Name: transacciones_usuarios_id_tip_usu_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY transacciones_usuarios
    ADD CONSTRAINT transacciones_usuarios_id_tip_usu_usu_fkey FOREIGN KEY (id_tip_usu_usu) REFERENCES tipos_usuarios__usuarios(id_tip_usu_usu) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2273 (class 2606 OID 17718)
-- Dependencies: 1727 2135 1692
-- Name: tratamientos_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2274 (class 2606 OID 17723)
-- Dependencies: 1725 2192 1727
-- Name: tratamientos_pacientes_id_tra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_id_tra_fkey FOREIGN KEY (id_tra) REFERENCES tratamientos(id_tra) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2336 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: desarrollo_g
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM desarrollo_g;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-10-13 22:49:58

--
-- PostgreSQL database dump complete
--
