﻿--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.3
-- Dumped by pg_dump version 9.0.3
-- Started on 2011-12-29 09:49:19

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 6 (class 2615 OID 30789)
-- Name: saib_model; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA saib_model;


ALTER SCHEMA saib_model OWNER TO postgres;

--
-- TOC entry 476 (class 2612 OID 11574)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 326 (class 1247 OID 30792)
-- Dependencies: 7 1668
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
-- TOC entry 2362 (class 0 OID 0)
-- Dependencies: 326
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
-- TOC entry 19 (class 1255 OID 30793)
-- Dependencies: 7 476
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
-- TOC entry 2363 (class 0 OID 0)
-- Dependencies: 19
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
-- TOC entry 20 (class 1255 OID 30794)
-- Dependencies: 7 476
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
-- TOC entry 2364 (class 0 OID 0)
-- Dependencies: 20
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
-- TOC entry 21 (class 1255 OID 30795)
-- Dependencies: 476 7
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
-- TOC entry 2365 (class 0 OID 0)
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
-- TOC entry 22 (class 1255 OID 30796)
-- Dependencies: 7 476
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
-- TOC entry 2366 (class 0 OID 0)
-- Dependencies: 22
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
-- TOC entry 23 (class 1255 OID 30797)
-- Dependencies: 476 7
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
-- TOC entry 2367 (class 0 OID 0)
-- Dependencies: 23
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
-- TOC entry 25 (class 1255 OID 30798)
-- Dependencies: 476 7
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
-- TOC entry 2368 (class 0 OID 0)
-- Dependencies: 25
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
-- TOC entry 26 (class 1255 OID 30799)
-- Dependencies: 476 7
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
-- TOC entry 2369 (class 0 OID 0)
-- Dependencies: 26
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
-- TOC entry 27 (class 1255 OID 30800)
-- Dependencies: 7 476
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
-- TOC entry 2370 (class 0 OID 0)
-- Dependencies: 27
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
-- TOC entry 24 (class 1255 OID 30801)
-- Dependencies: 476 7
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
-- TOC entry 2371 (class 0 OID 0)
-- Dependencies: 24
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
-- TOC entry 28 (class 1255 OID 30802)
-- Dependencies: 476 7
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
-- TOC entry 2372 (class 0 OID 0)
-- Dependencies: 28
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
-- TOC entry 38 (class 1255 OID 30804)
-- Dependencies: 7 476
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
	_str_chk_for_inf	TEXT;

	_id_otr_enf_mic		enfermedades_pacientes.id_enf_pac%TYPE;
	_str_otr_enf_mic	enfermedades_pacientes.otr_enf_mic%TYPE;

	_id_otr_for_inf		forma_infecciones__pacientes.id_for_inf%TYPE;
	_str_otr_for_inf	forma_infecciones__pacientes.otr_for_inf%TYPE;	

	-- variables para trabajar con otros
	_str_data_otr		TEXT;
	_arr_str_data_otr	TEXT[];
	_arr_str_data_otr_elm	TEXT[];
	_bol_otr		BOOLEAN DEFAULT FALSE;

	-- cadena para manipular el array	
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
	_str_chk_for_inf	:= _datos[6];


	_str_otr_enf_mic	:= _datos[7];
	_id_otr_enf_mic 	:= _datos[8];
	
	_id_otr_for_inf		:= _datos[9];
	_str_otr_for_inf	:= _datos[10];

	_str_data_otr		:= _datos[11];
		
	_id_doc			:= _datos[12];	
	
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

			IF (_id_otr_enf_mic = _arr_1[i])THEN
				INSERT INTO enfermedades_pacientes (
					id_tip_mic_pac,
					id_enf_mic,
					otr_enf_mic					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i],
					_str_otr_enf_mic
				);
			ELSE
				INSERT INTO enfermedades_pacientes (
					id_tip_mic_pac,
					id_enf_mic					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i]
				);
			END IF;
		END LOOP;
	END IF;

	-- tipo de consulta del paciente referidos al historico
	--DELETE FROM lesiones_partes_cuerpo__paciente WHERE id_his = _id_his;

	_arr_3 := STRING_TO_ARRAY(_str_les,',');
	
	IF (ARRAY_UPPER(_arr_3,1) > 0)THEN

		_arr_str_data_otr = STRING_TO_ARRAY(_str_data_otr,',');	
		
	
		FOR i IN 1..(ARRAY_UPPER(_arr_3,1)) LOOP
			_bol_otr := FALSE;
			_arr_2 := STRING_TO_ARRAY(replace(replace(_arr_3[i],'(',''),')',''),';');

			<<mifor>>
			FOR i IN 1..(ARRAY_UPPER(_arr_str_data_otr,1))LOOP			
				_arr_str_data_otr_elm := STRING_TO_ARRAY(_arr_str_data_otr[i],';');
				IF(_arr_str_data_otr_elm[1]::INTEGER = _arr_2[1] AND _arr_str_data_otr_elm[2]::INTEGER = _arr_2[2])THEN
					_str_data_otr := _arr_str_data_otr_elm[3];					
					_bol_otr := TRUE;
					EXIT mifor;
				END IF;
			END LOOP mifor;

			--coloca los comentarios de los otros en lesiones
			IF _bol_otr THEN

				INSERT INTO lesiones_partes_cuerpos__pacientes (
					id_tip_mic_pac,
					id_cat_cue_les,
					id_par_cue_cat_cue,
					otr_les_par_cue
				) VALUES (
					_id_tip_mic_pac,
					_arr_2[1],
					_arr_2[2],	
					_str_data_otr			
				);
			ELSE
			
				INSERT INTO lesiones_partes_cuerpos__pacientes 
				(
					id_tip_mic_pac,
					id_cat_cue_les,
					id_par_cue_cat_cue
				) VALUES (
					_id_tip_mic_pac,
					_arr_2[1],
					_arr_2[2]				
				);
			END IF;
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

	-- insertando la forma de infeccion de enfermedades del paciente
	_arr_1 := STRING_TO_ARRAY(_str_chk_for_inf,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP
			IF _id_otr_for_inf = _arr_1[i] THEN 
				INSERT INTO forma_infecciones__pacientes (
					id_tip_mic_pac,
					id_for_inf,
					otr_for_inf					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i],
					_str_otr_for_inf
				);
			ELSE
			
				INSERT INTO forma_infecciones__pacientes (
					id_tip_mic_pac,
					id_for_inf					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i]
				);
			END IF;
		END LOOP;
	END IF;

	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_insertar_micosis_pacientes(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2373 (class 0 OID 0)
-- Dependencies: 38
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
		''1,4,7,18'', 
		''(3;1),(22;1),(7;2),(22;2),(13;3),(23;3),(14;4),(23;4)'', 
		''1,3,5'', 
		'''', 
		''super mic'', 
		''18'', 
		''-1'', 
		'''', 
		''22;1;uno,22;2;dos,23;3;tres,23;4;cuatro'', 
		''32'' 
	] ) AS result

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 15/08/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 29/12/2011

';


--
-- TOC entry 29 (class 1255 OID 30805)
-- Dependencies: 476 7
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
-- TOC entry 2374 (class 0 OID 0)
-- Dependencies: 29
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
-- TOC entry 37 (class 1255 OID 30806)
-- Dependencies: 7 476
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
	_str_chk_for_inf	TEXT;

	_str_otr_enf_pac	enfermedades_pacientes.otr_enf_mic%TYPE;
	_id_otr_enf_pac		enfermedades_pacientes.id_enf_pac%TYPE;

	_id_otr_for_inf		forma_infecciones__pacientes.id_for_inf%TYPE;
	_str_otr_for_inf	forma_infecciones__pacientes.otr_for_inf%TYPE;

	-- variables para trabajar con otros
	_str_data_otr		TEXT;
	_arr_str_data_otr	TEXT[];
	_arr_str_data_otr_elm	TEXT[];
	_bol_otr		BOOLEAN DEFAULT FALSE;
	
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
	_str_chk_for_inf	:= _datos[5];

	_str_otr_enf_pac	:= _datos[6];
	_id_otr_enf_pac		:= _datos[7];
	
	_str_data_otr		:= _datos[8];

	_id_otr_for_inf		:= _datos[9];
	_str_otr_for_inf	:= _datos[10];
	
	_id_doc			:= _datos[11];	
		
	-- enfermedades del paciente
	DELETE FROM enfermedades_pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac;

	_arr_1 := STRING_TO_ARRAY(_str_enf_pac,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP
			IF _id_otr_enf_pac = _arr_1[i] THEN
				INSERT INTO enfermedades_pacientes (
					id_tip_mic_pac,
					id_enf_mic,
					otr_enf_mic					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i],
					_str_otr_enf_pac
				);
			ELSE
				INSERT INTO enfermedades_pacientes (
					id_tip_mic_pac,
					id_enf_mic					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i]
				);
			END IF;
		END LOOP;
	END IF;

	-- tipo de consulta del paciente referidos al historico
	DELETE FROM lesiones_partes_cuerpos__pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac;
	
	_arr_3 := STRING_TO_ARRAY(_str_les,',');
	
	IF (ARRAY_UPPER(_arr_3,1) > 0)THEN
	
		_arr_str_data_otr = STRING_TO_ARRAY(_str_data_otr,',');		
		
		
		FOR i IN 1..(ARRAY_UPPER(_arr_3,1)) LOOP
			_bol_otr := FALSE;
			_arr_2 := STRING_TO_ARRAY(replace(replace(_arr_3[i] ,'(',''),')',''),';');

			<<mifor>>
			FOR i IN 1..(ARRAY_UPPER(_arr_str_data_otr,1))LOOP			
				_arr_str_data_otr_elm := STRING_TO_ARRAY(_arr_str_data_otr[i],';');
				IF(_arr_str_data_otr_elm[1]::INTEGER = _arr_2[1] AND _arr_str_data_otr_elm[2]::INTEGER = _arr_2[2])THEN
					_str_data_otr := _arr_str_data_otr_elm[3];					
					_bol_otr := TRUE;
					EXIT mifor;
				END IF;
			END LOOP mifor;
			
			--coloca los comentarios de los otros en lesiones
			IF _bol_otr THEN

				INSERT INTO lesiones_partes_cuerpos__pacientes (
					id_tip_mic_pac,
					id_cat_cue_les,
					id_par_cue_cat_cue,
					otr_les_par_cue
				) VALUES (
					_id_tip_mic_pac,
					_arr_2[1],
					_arr_2[2],	
					_str_data_otr			
				);

			ELSE

				INSERT INTO lesiones_partes_cuerpos__pacientes (
					id_tip_mic_pac,
					id_cat_cue_les,
					id_par_cue_cat_cue
				) VALUES (
					_id_tip_mic_pac,
					_arr_2[1],
					_arr_2[2]				
				);
			
			END IF;
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

	-- forma de infeccion
	DELETE FROM forma_infecciones__pacientes WHERE id_tip_mic_pac = _id_tip_mic_pac;

	_arr_1 := STRING_TO_ARRAY(_str_chk_for_inf,',');
	IF (ARRAY_UPPER(_arr_1,1) > 0)THEN
		FOR i IN 1..(ARRAY_UPPER(_arr_1,1)) LOOP

			IF _id_otr_for_inf = _arr_1[i] THEN 

				INSERT INTO forma_infecciones__pacientes (
					id_tip_mic_pac,
					id_for_inf,
					otr_for_inf					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i],
					_str_otr_for_inf
				);
			ELSE
				INSERT INTO forma_infecciones__pacientes (
					id_tip_mic_pac,
					id_for_inf					
				) VALUES (
					_id_tip_mic_pac,
					_arr_1[i]
				);
			END IF;
		END LOOP;
	END IF;

	RETURN 1;

END;$_$;


ALTER FUNCTION public.med_modificar_micosis_pacientes(character varying[]) OWNER TO desarrollo_g;

--
-- TOC entry 2375 (class 0 OID 0)
-- Dependencies: 37
-- Name: FUNCTION med_modificar_micosis_pacientes(character varying[]); Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON FUNCTION med_modificar_micosis_pacientes(character varying[]) IS '
NOMBRE: med_modificar_micosis_pacientes
TIPO: Function (store procedure)

PARAMETROS: Recibe 4 Parámetros
		
	1:  Id tipo micosis paciente.
	2:  String de las enfermedades del paciente, separados por ","
	3:  String de las lesiones del paciente.
	4:  String nombre de la otra micosis
	5:  Id de la otra micosis	
	6:  Id del doctor.	

DESCRIPCION: 
	Modifica las enfermedades y las lesiones del paciente

RETORNO:
	1: La función se ejecutó exitosamente	
	 
EJEMPLO DE LLAMADA:
	SELECT med_modificar_micosis_pacientes(ARRAY[ 
		''60'', 
		''1,4,5,7,18'', 
		''(3;1),(22;1),(2;1),(7;2),(22;2),(5;2),(13;3),(23;3),(10;3),(14;4),(21;4),(23;4)'', 
		''1,3,5,7'', 
		'''', 
		''super mic'', 
		''18'', 
		''22;1;uno,22;2;dos,23;3;tres,23;4;cuatro'', 
		''-1'', 
		'''', 
		''32'' 
	] ) AS result
AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 15/08/2011

AUTOR DE MODIFICACION: Luis Marin
FECHA DE MODIFICACION: 27/12/2011

AUTOR DE MODIFICACION: Lisseth Lozada
FECHA DE MODIFICACION: 29/12/2011
';


--
-- TOC entry 30 (class 1255 OID 30807)
-- Dependencies: 476 7
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
	_sex_pac	pacientes.sex_pac%TYPE;
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
	_sex_pac	:= _datos[17];

	-- centros de salud pacientes
	
	
	/* validando pacientes */
	IF EXISTS (SELECT 1 FROM pacientes WHERE id_pac = _id_pac::integer) THEN  

		/*Busco el registro anterior del paciente*/
		SELECT 	id_pac,ape_pac,nom_pac,ced_pac,fec_nac_pac,tel_hab_pac,tel_cel_pac,ciu_pac,id_pai,id_est,id_mun,sex_pac, 
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
			END AS ocu_pac INTO _reg_pac
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
			id_mun 		= _id_mun,
			sex_pac		= _sex_pac			

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
				formato_campo_xml('Sexo', 		coalesce(_sex_pac::text, 'ninguno'), 		coalesce(_reg_pac.sex_pac::text, 'ninguno'))||  
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
-- TOC entry 2376 (class 0 OID 0)
-- Dependencies: 30
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
	17: Sexo del paciente

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
                ''MP'',
                ''F''
            ]) AS result;

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 16/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 24/10/2011
DESCRIPCIÓN: Se agregó en la función un nuevo campo sex_pac.
';


--
-- TOC entry 36 (class 1255 OID 30809)
-- Dependencies: 476 7
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

	_id_otr_mue_cli		muestras_pacientes.id_mue_pac%TYPE;
	_str_otr_mue_cli	muestras_pacientes.otr_mue_cli%TYPE;
	
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
	
	_id_otr_mue_cli		:= _datos[3];
	_str_otr_mue_cli	:= _datos[4];
			
	_id_doc			:= _datos[5];	
	_tra_usu		:= _datos[6];



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
			IF (_id_otr_mue_cli = _arr[i])THEN
				INSERT INTO muestras_pacientes (
					id_his,
					id_mue_cli,
					otr_mue_cli					
				) VALUES (
					_id_his,
					_arr[i],
					_str_otr_mue_cli
				);
			ELSE
				INSERT INTO muestras_pacientes (
					id_his,
					id_mue_cli					
				) VALUES (
					_id_his,
					_arr[i]
				);
			END IF;

			SELECT nom_mue_cli INTO _reg_act FROM muestras_pacientes mp LEFT JOIN muestras_clinicas mc ON(mp.id_mue_cli = mc.id_mue_cli) WHERE mc.id_mue_cli = _arr[i];

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
-- TOC entry 2377 (class 0 OID 0)
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
                ''1,3,4,8,9,36'',
                ''36'',
                ''Otra Clinica'',               
                ''32'',
                ''MCP''                
                ]
            ) AS result 

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 03/08/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 25/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.
';


--
-- TOC entry 31 (class 1255 OID 30810)
-- Dependencies: 476 7
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
-- TOC entry 2378 (class 0 OID 0)
-- Dependencies: 31
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
-- TOC entry 33 (class 1255 OID 30811)
-- Dependencies: 476 7
-- Name: med_registrar_informacion_adicional(character varying[]); Type: FUNCTION; Schema: public; Owner: desarrollo_g
--

CREATE FUNCTION med_registrar_informacion_adicional(character varying[]) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_datos ALIAS FOR $1;

	-- informacion del paciente	
	_str_cen_sal		TEXT;
	_str_tip_con		TEXT;
	_str_con_ani		TEXT;
	_str_tra_pre		TEXT;
	_tie_evo		tiempo_evoluciones.tie_evo%TYPE;
	_id_doc			doctores.id_doc%TYPE;
	_tra_usu		transacciones.cod_tip_tra%TYPE;
	_str_otr_ani		contactos_animales.otr_ani%TYPE;
	_id_otr_ani		contactos_animales.id_ani%TYPE;
	_str_otr_tip_con	tipos_consultas_pacientes.otr_tip_con%TYPE;
	_id_otr_tip_con		tipos_consultas_pacientes.id_tip_con%TYPE;

	_str_otr_cen_sal	centro_salud_pacientes.otr_cen_sal%TYPE;
	_id_otr_cen_sal		centro_salud_pacientes.id_cen_sal%TYPE;
	
	_str_otr_tra		tratamientos_pacientes.otr_tra%TYPE;
	_id_otr_tra		tratamientos_pacientes.id_tra_pac%TYPE;
	
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
	
	_id_otr_ani		:= _datos[7];	
	_str_otr_ani		:= _datos[8];
	
	_id_otr_tip_con 	:= _datos[9];
	_str_otr_tip_con	:= _datos[10];

	_id_otr_cen_sal		:= _datos[11];
	_str_otr_cen_sal	:= _datos[12];
	
	_id_otr_tra 		:= _datos[13];
	_str_otr_tra		:= _datos[14];
		
	_id_doc			:= _datos[15];	
	_tra_usu		:= _datos[16];


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
			IF (_id_otr_cen_sal = _arr[i])THEN
				INSERT INTO centro_salud_pacientes (
					id_his,
					id_cen_sal,
					otr_cen_sal					
				) VALUES (
					_id_his,
					_arr[i],
					_str_otr_cen_sal
				);
			ELSE
				INSERT INTO centro_salud_pacientes (
					id_his,
					id_cen_sal					
				) VALUES (
					_id_his,
					_arr[i]
				);
			END IF;
			
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
			
			IF (_id_otr_tip_con = _arr[i])THEN
				INSERT INTO tipos_consultas_pacientes (
					id_his,
					id_tip_con,
					otr_tip_con					
				) VALUES (
					_id_his,
					_arr[i],
					_str_otr_tip_con
				);
			ELSE
				INSERT INTO tipos_consultas_pacientes (
					id_his,
					id_tip_con					
				) VALUES (
					_id_his,
					_arr[i]
				);
			END IF;
			
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
			-- Verificando si el id del animal es igual al id del animal otros que viene por parametro
			IF (_id_otr_ani = _arr[i])THEN
				INSERT INTO contactos_animales (
					id_his,
					id_ani,
					otr_ani					
				) VALUES (
					_id_his,
					_arr[i],
					_str_otr_ani					
				);				
			ELSE
				INSERT INTO contactos_animales (
					id_his,
					id_ani					
				) VALUES (
					_id_his,
					_arr[i]
				);
			END IF;
			
			
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
		
			IF (_id_otr_tra = _arr[i])THEN
				INSERT INTO tratamientos_pacientes (
					id_his,
					id_tra,
					otr_tra					
				) VALUES (
					_id_his,
					_arr[i],
					_str_otr_tra
				);
			ELSE
				INSERT INTO tratamientos_pacientes (
					id_his,
					id_tra					
				) VALUES (
					_id_his,
					_arr[i]
				);
			END IF;
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
-- TOC entry 2379 (class 0 OID 0)
-- Dependencies: 33
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
                ''6'',
				''IAP''               
                ]
            ) AS result 

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 16/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.

AUTOR DE MODIFICACIÓN: Luis Marin
FECHA DE MODIFICACIÓN:14/12/2011
DESCRIPCIÓN: Se agregó la opción de poder agregar otros animales.
';


--
-- TOC entry 32 (class 1255 OID 30813)
-- Dependencies: 7 476
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
	_sex_pac	pacientes.sex_pac%TYPE;
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
	_sex_pac	:= _datos[16];

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
			id_doc,
			sex_pac		
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
			_id_doc,
			_sex_pac
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
				formato_campo_xml('Sexo', 		coalesce(_sex_pac::text, 'ninguno'), 		'ninguno')||   
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
-- TOC entry 2380 (class 0 OID 0)
-- Dependencies: 32
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
	16: Sexo del paciente
	

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
                ''F''
            ]) AS result

AUTOR DE CREACIÓN: Luis Marin
FECHA DE CREACIÓN: 09/06/2011

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 16/08/2011
DESCRIPCIÓN: Se agregó en la función el armado del xml para la inserción de la auditoría de las transacciones.

AUTOR DE MODIFICACIÓN: Lisseth Lozada
FECHA DE MODIFICACIÓN: 24/10/2011
DESCRIPCIÓN: Se agregó en la función un nuevo campo sex_pac.
';


--
-- TOC entry 34 (class 1255 OID 30815)
-- Dependencies: 7 476
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
-- TOC entry 2381 (class 0 OID 0)
-- Dependencies: 34
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
-- TOC entry 35 (class 1255 OID 30816)
-- Dependencies: 476 7 326
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
-- TOC entry 2382 (class 0 OID 0)
-- Dependencies: 35
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
-- TOC entry 1669 (class 1259 OID 30817)
-- Dependencies: 7
-- Name: animales; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE animales (
    id_ani integer NOT NULL,
    nom_ani character varying(20)
);


ALTER TABLE public.animales OWNER TO desarrollo_g;

--
-- TOC entry 1670 (class 1259 OID 30820)
-- Dependencies: 1669 7
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
-- TOC entry 2383 (class 0 OID 0)
-- Dependencies: 1670
-- Name: animales_id_ani_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE animales_id_ani_seq OWNED BY animales.id_ani;


--
-- TOC entry 2384 (class 0 OID 0)
-- Dependencies: 1670
-- Name: animales_id_ani_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('animales_id_ani_seq', 1, false);


--
-- TOC entry 1671 (class 1259 OID 30822)
-- Dependencies: 7
-- Name: antecedentes_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE antecedentes_pacientes (
    id_ant_pac integer NOT NULL,
    id_ant_per integer NOT NULL,
    id_pac integer
);


ALTER TABLE public.antecedentes_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1672 (class 1259 OID 30825)
-- Dependencies: 7 1671
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
-- TOC entry 2385 (class 0 OID 0)
-- Dependencies: 1672
-- Name: antecedentes_pacientes_id_ant_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE antecedentes_pacientes_id_ant_pac_seq OWNED BY antecedentes_pacientes.id_ant_pac;


--
-- TOC entry 2386 (class 0 OID 0)
-- Dependencies: 1672
-- Name: antecedentes_pacientes_id_ant_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('antecedentes_pacientes_id_ant_pac_seq', 40, true);


--
-- TOC entry 1673 (class 1259 OID 30827)
-- Dependencies: 7
-- Name: antecedentes_personales; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE antecedentes_personales (
    id_ant_per integer NOT NULL,
    nom_ant_per character varying(100)
);


ALTER TABLE public.antecedentes_personales OWNER TO desarrollo_g;

--
-- TOC entry 1674 (class 1259 OID 30830)
-- Dependencies: 1673 7
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
-- TOC entry 2387 (class 0 OID 0)
-- Dependencies: 1674
-- Name: antecedentes_personales_id_ant_per_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE antecedentes_personales_id_ant_per_seq OWNED BY antecedentes_personales.id_ant_per;


--
-- TOC entry 2388 (class 0 OID 0)
-- Dependencies: 1674
-- Name: antecedentes_personales_id_ant_per_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('antecedentes_personales_id_ant_per_seq', 1, false);


--
-- TOC entry 1675 (class 1259 OID 30832)
-- Dependencies: 7
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
-- TOC entry 2389 (class 0 OID 0)
-- Dependencies: 1675
-- Name: TABLE auditoria_transacciones; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON TABLE auditoria_transacciones IS 'Se guarda todos los eventos generados por los usuarios';


--
-- TOC entry 2390 (class 0 OID 0)
-- Dependencies: 1675
-- Name: COLUMN auditoria_transacciones.data_xml; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN auditoria_transacciones.data_xml IS 'Se guarda las modificaciones de la tabla y atributos realizada por los usuarios, todo en forma de XML';


--
-- TOC entry 1676 (class 1259 OID 30838)
-- Dependencies: 1675 7
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
-- TOC entry 2391 (class 0 OID 0)
-- Dependencies: 1676
-- Name: auditoria_transacciones_id_aud_tra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE auditoria_transacciones_id_aud_tra_seq OWNED BY auditoria_transacciones.id_aud_tra;


--
-- TOC entry 2392 (class 0 OID 0)
-- Dependencies: 1676
-- Name: auditoria_transacciones_id_aud_tra_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('auditoria_transacciones_id_aud_tra_seq', 56, true);


--
-- TOC entry 1677 (class 1259 OID 30840)
-- Dependencies: 7
-- Name: categorias__cuerpos_micosis; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE categorias__cuerpos_micosis (
    id_cat_cue_mic integer NOT NULL,
    id_cat_cue integer NOT NULL,
    id_tip_mic integer NOT NULL
);


ALTER TABLE public.categorias__cuerpos_micosis OWNER TO desarrollo_g;

--
-- TOC entry 1678 (class 1259 OID 30843)
-- Dependencies: 7 1677
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
-- TOC entry 2393 (class 0 OID 0)
-- Dependencies: 1678
-- Name: categorias__cuerpos_micosis_id_cat_cue_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE categorias__cuerpos_micosis_id_cat_cue_mic_seq OWNED BY categorias__cuerpos_micosis.id_cat_cue_mic;


--
-- TOC entry 2394 (class 0 OID 0)
-- Dependencies: 1678
-- Name: categorias__cuerpos_micosis_id_cat_cue_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('categorias__cuerpos_micosis_id_cat_cue_mic_seq', 17, true);


--
-- TOC entry 1679 (class 1259 OID 30845)
-- Dependencies: 7
-- Name: categorias_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE categorias_cuerpos (
    id_cat_cue integer NOT NULL,
    nom_cat_cue character varying(20)
);


ALTER TABLE public.categorias_cuerpos OWNER TO desarrollo_g;

--
-- TOC entry 1680 (class 1259 OID 30848)
-- Dependencies: 7
-- Name: categorias_cuerpos__lesiones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE categorias_cuerpos__lesiones (
    id_cat_cue_les integer NOT NULL,
    id_les integer,
    id_cat_cue integer
);


ALTER TABLE public.categorias_cuerpos__lesiones OWNER TO desarrollo_g;

--
-- TOC entry 1681 (class 1259 OID 30851)
-- Dependencies: 1679 7
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
-- TOC entry 2395 (class 0 OID 0)
-- Dependencies: 1681
-- Name: categorias_cuerpos_id_cat_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE categorias_cuerpos_id_cat_cue_seq OWNED BY categorias_cuerpos.id_cat_cue;


--
-- TOC entry 2396 (class 0 OID 0)
-- Dependencies: 1681
-- Name: categorias_cuerpos_id_cat_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('categorias_cuerpos_id_cat_cue_seq', 4, true);


SET default_tablespace = '';

--
-- TOC entry 1682 (class 1259 OID 30853)
-- Dependencies: 7
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
-- TOC entry 2397 (class 0 OID 0)
-- Dependencies: 1682
-- Name: COLUMN centro_salud_doctores.id_cen_sal_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.id_cen_sal_doc IS 'Identificación del Centro de Salud del doctor';


--
-- TOC entry 2398 (class 0 OID 0)
-- Dependencies: 1682
-- Name: COLUMN centro_salud_doctores.id_cen_sal; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.id_cen_sal IS 'Identificación del Centro de Salud';


--
-- TOC entry 2399 (class 0 OID 0)
-- Dependencies: 1682
-- Name: COLUMN centro_salud_doctores.id_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.id_doc IS 'Identificación del doctor';


--
-- TOC entry 2400 (class 0 OID 0)
-- Dependencies: 1682
-- Name: COLUMN centro_salud_doctores.otr_cen_sal; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN centro_salud_doctores.otr_cen_sal IS 'Otro Centro de Salud';


--
-- TOC entry 1683 (class 1259 OID 30856)
-- Dependencies: 7 1682
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
-- TOC entry 2401 (class 0 OID 0)
-- Dependencies: 1683
-- Name: centro_salud_doctores_id_cen_sal_doc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE centro_salud_doctores_id_cen_sal_doc_seq OWNED BY centro_salud_doctores.id_cen_sal_doc;


--
-- TOC entry 2402 (class 0 OID 0)
-- Dependencies: 1683
-- Name: centro_salud_doctores_id_cen_sal_doc_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('centro_salud_doctores_id_cen_sal_doc_seq', 11, true);


SET default_tablespace = saib;

--
-- TOC entry 1684 (class 1259 OID 30858)
-- Dependencies: 7
-- Name: centro_saluds; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE centro_saluds (
    id_cen_sal integer NOT NULL,
    nom_cen_sal character varying(100) NOT NULL,
    des_cen_sal character varying(100)
);


ALTER TABLE public.centro_saluds OWNER TO desarrollo_g;

--
-- TOC entry 1685 (class 1259 OID 30861)
-- Dependencies: 7 1684
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
-- TOC entry 2403 (class 0 OID 0)
-- Dependencies: 1685
-- Name: centro_salud_id_cen_sal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE centro_salud_id_cen_sal_seq OWNED BY centro_saluds.id_cen_sal;


--
-- TOC entry 2404 (class 0 OID 0)
-- Dependencies: 1685
-- Name: centro_salud_id_cen_sal_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('centro_salud_id_cen_sal_seq', 35, true);


--
-- TOC entry 1686 (class 1259 OID 30863)
-- Dependencies: 7
-- Name: centro_salud_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE centro_salud_pacientes (
    id_cen_sal_pac integer NOT NULL,
    id_his integer NOT NULL,
    id_cen_sal integer NOT NULL,
    otr_cen_sal character varying(100)
);


ALTER TABLE public.centro_salud_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1687 (class 1259 OID 30866)
-- Dependencies: 1686 7
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
-- TOC entry 2405 (class 0 OID 0)
-- Dependencies: 1687
-- Name: centro_salud_pacientes_id_cen_sal_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE centro_salud_pacientes_id_cen_sal_pac_seq OWNED BY centro_salud_pacientes.id_cen_sal_pac;


--
-- TOC entry 2406 (class 0 OID 0)
-- Dependencies: 1687
-- Name: centro_salud_pacientes_id_cen_sal_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('centro_salud_pacientes_id_cen_sal_pac_seq', 198, true);


--
-- TOC entry 1688 (class 1259 OID 30868)
-- Dependencies: 7
-- Name: contactos_animales; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE contactos_animales (
    id_con_ani integer NOT NULL,
    id_his integer NOT NULL,
    id_ani integer NOT NULL,
    otr_ani character varying(100)
);


ALTER TABLE public.contactos_animales OWNER TO desarrollo_g;

--
-- TOC entry 1689 (class 1259 OID 30871)
-- Dependencies: 7 1688
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
-- TOC entry 2407 (class 0 OID 0)
-- Dependencies: 1689
-- Name: contactos_animales_id_con_ani_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE contactos_animales_id_con_ani_seq OWNED BY contactos_animales.id_con_ani;


--
-- TOC entry 2408 (class 0 OID 0)
-- Dependencies: 1689
-- Name: contactos_animales_id_con_ani_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('contactos_animales_id_con_ani_seq', 173, true);


--
-- TOC entry 1690 (class 1259 OID 30873)
-- Dependencies: 2054 7
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
-- TOC entry 2409 (class 0 OID 0)
-- Dependencies: 1690
-- Name: TABLE doctores; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON TABLE doctores IS 'Registro de todos los doctores que del aplicativo';


--
-- TOC entry 2410 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.id_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.id_doc IS 'identificador único para los doctores';


--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.nom_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.nom_doc IS 'Nombre del doctor';


--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.ape_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.ape_doc IS 'Apellido del doctor';


--
-- TOC entry 2413 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.ced_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.ced_doc IS 'Cédula del doctor';


--
-- TOC entry 2414 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.pas_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.pas_doc IS 'Contraseña del doctor';


--
-- TOC entry 2415 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.tel_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.tel_doc IS 'Teléfono del doctor';


--
-- TOC entry 2416 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.cor_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.cor_doc IS 'Correo electronico del doctor';


--
-- TOC entry 2417 (class 0 OID 0)
-- Dependencies: 1690
-- Name: COLUMN doctores.log_doc; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN doctores.log_doc IS 'Login con el que se loguara el doctor';


--
-- TOC entry 1691 (class 1259 OID 30880)
-- Dependencies: 1690 7
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
-- TOC entry 2418 (class 0 OID 0)
-- Dependencies: 1691
-- Name: doctores_id_doc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE doctores_id_doc_seq OWNED BY doctores.id_doc;


--
-- TOC entry 2419 (class 0 OID 0)
-- Dependencies: 1691
-- Name: doctores_id_doc_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('doctores_id_doc_seq', 34, true);


--
-- TOC entry 1692 (class 1259 OID 30882)
-- Dependencies: 7
-- Name: enfermedades_micologicas; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE enfermedades_micologicas (
    id_enf_mic integer NOT NULL,
    nom_enf_mic character varying(100) NOT NULL,
    id_tip_mic integer NOT NULL
);


ALTER TABLE public.enfermedades_micologicas OWNER TO desarrollo_g;

--
-- TOC entry 1693 (class 1259 OID 30885)
-- Dependencies: 1692 7
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
-- TOC entry 2420 (class 0 OID 0)
-- Dependencies: 1693
-- Name: enfermedades_micologicas_id_enf_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE enfermedades_micologicas_id_enf_mic_seq OWNED BY enfermedades_micologicas.id_enf_mic;


--
-- TOC entry 2421 (class 0 OID 0)
-- Dependencies: 1693
-- Name: enfermedades_micologicas_id_enf_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('enfermedades_micologicas_id_enf_mic_seq', 28, true);


--
-- TOC entry 1694 (class 1259 OID 30887)
-- Dependencies: 7
-- Name: enfermedades_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE enfermedades_pacientes (
    id_enf_pac integer NOT NULL,
    id_enf_mic integer NOT NULL,
    otr_enf_mic character varying(100),
    esp_enf_mic character varying(20),
    id_tip_mic_pac integer
);


ALTER TABLE public.enfermedades_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1695 (class 1259 OID 30890)
-- Dependencies: 1694 7
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
-- TOC entry 2422 (class 0 OID 0)
-- Dependencies: 1695
-- Name: enfermedades_pacientes_id_enf_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE enfermedades_pacientes_id_enf_pac_seq OWNED BY enfermedades_pacientes.id_enf_pac;


--
-- TOC entry 2423 (class 0 OID 0)
-- Dependencies: 1695
-- Name: enfermedades_pacientes_id_enf_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('enfermedades_pacientes_id_enf_pac_seq', 368, true);


SET default_tablespace = '';

--
-- TOC entry 1696 (class 1259 OID 30892)
-- Dependencies: 7
-- Name: estados; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE estados (
    id_est integer NOT NULL,
    des_est character varying(100),
    id_pai integer
);


ALTER TABLE public.estados OWNER TO desarrollo_g;

--
-- TOC entry 1697 (class 1259 OID 30895)
-- Dependencies: 1696 7
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
-- TOC entry 2424 (class 0 OID 0)
-- Dependencies: 1697
-- Name: estados_id_est_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE estados_id_est_seq OWNED BY estados.id_est;


--
-- TOC entry 2425 (class 0 OID 0)
-- Dependencies: 1697
-- Name: estados_id_est_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('estados_id_est_seq', 6, true);


SET default_tablespace = saib;

--
-- TOC entry 1698 (class 1259 OID 30897)
-- Dependencies: 7
-- Name: forma_infecciones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE forma_infecciones (
    id_for_inf integer NOT NULL,
    des_for_inf character varying(255)
);


ALTER TABLE public.forma_infecciones OWNER TO desarrollo_g;

--
-- TOC entry 1699 (class 1259 OID 30900)
-- Dependencies: 7
-- Name: forma_infecciones__pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE forma_infecciones__pacientes (
    id_for_pac integer NOT NULL,
    id_for_inf integer NOT NULL,
    otr_for_inf character varying(100),
    id_tip_mic_pac integer
);


ALTER TABLE public.forma_infecciones__pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1700 (class 1259 OID 30903)
-- Dependencies: 7 1699
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
-- TOC entry 2426 (class 0 OID 0)
-- Dependencies: 1700
-- Name: forma_infecciones__pacientes_id_for_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE forma_infecciones__pacientes_id_for_pac_seq OWNED BY forma_infecciones__pacientes.id_for_pac;


--
-- TOC entry 2427 (class 0 OID 0)
-- Dependencies: 1700
-- Name: forma_infecciones__pacientes_id_for_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('forma_infecciones__pacientes_id_for_pac_seq', 55, true);


--
-- TOC entry 1701 (class 1259 OID 30905)
-- Dependencies: 7
-- Name: forma_infecciones__tipos_micosis; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE forma_infecciones__tipos_micosis (
    id_for_inf_tip_mic integer NOT NULL,
    id_tip_mic integer NOT NULL,
    id_for_inf integer NOT NULL
);


ALTER TABLE public.forma_infecciones__tipos_micosis OWNER TO desarrollo_g;

--
-- TOC entry 1702 (class 1259 OID 30908)
-- Dependencies: 7 1701
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
-- TOC entry 2428 (class 0 OID 0)
-- Dependencies: 1702
-- Name: forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq OWNED BY forma_infecciones__tipos_micosis.id_for_inf_tip_mic;


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 1702
-- Name: forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq', 21, true);


--
-- TOC entry 1703 (class 1259 OID 30910)
-- Dependencies: 1698 7
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
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 1703
-- Name: forma_infecciones_id_for_inf_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE forma_infecciones_id_for_inf_seq OWNED BY forma_infecciones.id_for_inf;


--
-- TOC entry 2431 (class 0 OID 0)
-- Dependencies: 1703
-- Name: forma_infecciones_id_for_inf_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('forma_infecciones_id_for_inf_seq', 12, true);


--
-- TOC entry 1704 (class 1259 OID 30912)
-- Dependencies: 2062 7
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
-- TOC entry 2432 (class 0 OID 0)
-- Dependencies: 1704
-- Name: COLUMN historiales_pacientes.des_adi_pac_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN historiales_pacientes.des_adi_pac_his IS '
	Discripción adicional de si el paciente padece o no una enfermedad u otra cosa adicional.
';


--
-- TOC entry 1705 (class 1259 OID 30919)
-- Dependencies: 1704 7
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
-- TOC entry 2433 (class 0 OID 0)
-- Dependencies: 1705
-- Name: historiales_pacientes_id_his_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE historiales_pacientes_id_his_seq OWNED BY historiales_pacientes.id_his;


--
-- TOC entry 2434 (class 0 OID 0)
-- Dependencies: 1705
-- Name: historiales_pacientes_id_his_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('historiales_pacientes_id_his_seq', 19, true);


SET default_tablespace = '';

--
-- TOC entry 1706 (class 1259 OID 30921)
-- Dependencies: 7
-- Name: lesiones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE lesiones (
    id_les integer NOT NULL,
    nom_les character varying(100)
);


ALTER TABLE public.lesiones OWNER TO desarrollo_g;

--
-- TOC entry 1707 (class 1259 OID 30924)
-- Dependencies: 1680 7
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
-- TOC entry 2435 (class 0 OID 0)
-- Dependencies: 1707
-- Name: lesiones__partes_cuerpos_id_les_par_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE lesiones__partes_cuerpos_id_les_par_cue_seq OWNED BY categorias_cuerpos__lesiones.id_cat_cue_les;


--
-- TOC entry 2436 (class 0 OID 0)
-- Dependencies: 1707
-- Name: lesiones__partes_cuerpos_id_les_par_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('lesiones__partes_cuerpos_id_les_par_cue_seq', 115, true);


--
-- TOC entry 1708 (class 1259 OID 30926)
-- Dependencies: 7 1706
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
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 1708
-- Name: lesiones_id_les_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE lesiones_id_les_seq OWNED BY lesiones.id_les;


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 1708
-- Name: lesiones_id_les_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('lesiones_id_les_seq', 71, true);


SET default_tablespace = saib;

--
-- TOC entry 1709 (class 1259 OID 30928)
-- Dependencies: 7
-- Name: lesiones_partes_cuerpos__pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE lesiones_partes_cuerpos__pacientes (
    id_les_par_cue_pac integer NOT NULL,
    otr_les_par_cue character varying(100),
    id_cat_cue_les integer,
    id_par_cue_cat_cue integer,
    id_tip_mic_pac integer
);


ALTER TABLE public.lesiones_partes_cuerpos__pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 1709
-- Name: COLUMN lesiones_partes_cuerpos__pacientes.id_les_par_cue_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN lesiones_partes_cuerpos__pacientes.id_les_par_cue_pac IS 'Leciones parted del cuerpo paciente';


--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 1709
-- Name: COLUMN lesiones_partes_cuerpos__pacientes.otr_les_par_cue; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN lesiones_partes_cuerpos__pacientes.otr_les_par_cue IS 'Otras leciones de la parte del cuerpo del paciente';


--
-- TOC entry 1710 (class 1259 OID 30931)
-- Dependencies: 7 1709
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
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 1710
-- Name: lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq OWNED BY lesiones_partes_cuerpos__pacientes.id_les_par_cue_pac;


--
-- TOC entry 2442 (class 0 OID 0)
-- Dependencies: 1710
-- Name: lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq', 309, true);


--
-- TOC entry 1711 (class 1259 OID 30933)
-- Dependencies: 7
-- Name: localizaciones_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE localizaciones_cuerpos (
    id_loc_cue integer NOT NULL,
    nom_loc_cue character varying(20) NOT NULL,
    id_par_cue integer
);


ALTER TABLE public.localizaciones_cuerpos OWNER TO desarrollo_g;

--
-- TOC entry 1712 (class 1259 OID 30936)
-- Dependencies: 1711 7
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
-- TOC entry 2443 (class 0 OID 0)
-- Dependencies: 1712
-- Name: localizaciones_cuerpos_id_loc_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE localizaciones_cuerpos_id_loc_cue_seq OWNED BY localizaciones_cuerpos.id_loc_cue;


--
-- TOC entry 2444 (class 0 OID 0)
-- Dependencies: 1712
-- Name: localizaciones_cuerpos_id_loc_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('localizaciones_cuerpos_id_loc_cue_seq', 1, false);


--
-- TOC entry 1713 (class 1259 OID 30938)
-- Dependencies: 7
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
-- TOC entry 1714 (class 1259 OID 30941)
-- Dependencies: 1713 7
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
-- TOC entry 2445 (class 0 OID 0)
-- Dependencies: 1714
-- Name: modulos_id_mod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE modulos_id_mod_seq OWNED BY modulos.id_mod;


--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 1714
-- Name: modulos_id_mod_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('modulos_id_mod_seq', 2, true);


--
-- TOC entry 1715 (class 1259 OID 30943)
-- Dependencies: 7
-- Name: muestras_clinicas; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE muestras_clinicas (
    id_mue_cli integer NOT NULL,
    nom_mue_cli character varying(100) NOT NULL
);


ALTER TABLE public.muestras_clinicas OWNER TO desarrollo_g;

--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 1715
-- Name: COLUMN muestras_clinicas.id_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_clinicas.id_mue_cli IS 'Identificacion de la muestra clinica';


--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 1715
-- Name: COLUMN muestras_clinicas.nom_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_clinicas.nom_mue_cli IS 'Nombre muestra clinica';


--
-- TOC entry 1716 (class 1259 OID 30946)
-- Dependencies: 1715 7
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
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 1716
-- Name: muestras_clinicas_id_mue_cli_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE muestras_clinicas_id_mue_cli_seq OWNED BY muestras_clinicas.id_mue_cli;


--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 1716
-- Name: muestras_clinicas_id_mue_cli_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('muestras_clinicas_id_mue_cli_seq', 1, false);


--
-- TOC entry 1717 (class 1259 OID 30948)
-- Dependencies: 7
-- Name: muestras_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE muestras_pacientes (
    id_mue_pac integer NOT NULL,
    id_his integer NOT NULL,
    id_mue_cli integer NOT NULL,
    otr_mue_cli character varying(100)
);


ALTER TABLE public.muestras_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2451 (class 0 OID 0)
-- Dependencies: 1717
-- Name: COLUMN muestras_pacientes.id_mue_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.id_mue_pac IS 'Id de la meustra del paciente';


--
-- TOC entry 2452 (class 0 OID 0)
-- Dependencies: 1717
-- Name: COLUMN muestras_pacientes.id_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.id_his IS 'Id del historial';


--
-- TOC entry 2453 (class 0 OID 0)
-- Dependencies: 1717
-- Name: COLUMN muestras_pacientes.id_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.id_mue_cli IS 'Id muestra cli';


--
-- TOC entry 2454 (class 0 OID 0)
-- Dependencies: 1717
-- Name: COLUMN muestras_pacientes.otr_mue_cli; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN muestras_pacientes.otr_mue_cli IS 'Otra meustra clinica';


--
-- TOC entry 1718 (class 1259 OID 30951)
-- Dependencies: 7 1717
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
-- TOC entry 2455 (class 0 OID 0)
-- Dependencies: 1718
-- Name: muestras_pacientes_id_mue_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE muestras_pacientes_id_mue_pac_seq OWNED BY muestras_pacientes.id_mue_pac;


--
-- TOC entry 2456 (class 0 OID 0)
-- Dependencies: 1718
-- Name: muestras_pacientes_id_mue_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('muestras_pacientes_id_mue_pac_seq', 100, true);


SET default_tablespace = '';

--
-- TOC entry 1719 (class 1259 OID 30953)
-- Dependencies: 7
-- Name: municipios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE municipios (
    id_mun integer NOT NULL,
    des_mun character varying(100),
    id_est integer
);


ALTER TABLE public.municipios OWNER TO desarrollo_g;

--
-- TOC entry 1720 (class 1259 OID 30956)
-- Dependencies: 7 1719
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
-- TOC entry 2457 (class 0 OID 0)
-- Dependencies: 1720
-- Name: municipios_id_mun_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE municipios_id_mun_seq OWNED BY municipios.id_mun;


--
-- TOC entry 2458 (class 0 OID 0)
-- Dependencies: 1720
-- Name: municipios_id_mun_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('municipios_id_mun_seq', 335, true);


SET default_tablespace = saib;

--
-- TOC entry 1721 (class 1259 OID 30958)
-- Dependencies: 2071 7
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
    fec_reg_pac timestamp with time zone DEFAULT now(),
    sex_pac character(1) NOT NULL
);


ALTER TABLE public.pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2459 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.id_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.id_pac IS 'Id paciente';


--
-- TOC entry 2460 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.ape_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ape_pac IS 'Apellido del paciente';


--
-- TOC entry 2461 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.nom_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.nom_pac IS 'Nombre del paciente';


--
-- TOC entry 2462 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.ced_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ced_pac IS 'Cedula del paciente';


--
-- TOC entry 2463 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.fec_nac_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.fec_nac_pac IS 'Fecha de nacimiento del paciente';


--
-- TOC entry 2464 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.nac_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.nac_pac IS 'Nacionalidad del paciente';


--
-- TOC entry 2465 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.ocu_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ocu_pac IS 'Ocupacion del paciente';


--
-- TOC entry 2466 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.ciu_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.ciu_pac IS 'Ciudad del paciente';


--
-- TOC entry 2467 (class 0 OID 0)
-- Dependencies: 1721
-- Name: COLUMN pacientes.fec_reg_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN pacientes.fec_reg_pac IS 'Fecha de registro del paciente';


--
-- TOC entry 1722 (class 1259 OID 30962)
-- Dependencies: 1721 7
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
-- TOC entry 2468 (class 0 OID 0)
-- Dependencies: 1722
-- Name: pacientes_id_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE pacientes_id_pac_seq OWNED BY pacientes.id_pac;


--
-- TOC entry 2469 (class 0 OID 0)
-- Dependencies: 1722
-- Name: pacientes_id_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('pacientes_id_pac_seq', 28, true);


SET default_tablespace = '';

--
-- TOC entry 1723 (class 1259 OID 30964)
-- Dependencies: 7
-- Name: paises; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE paises (
    id_pai integer NOT NULL,
    des_pai character varying(100),
    cod_pai character varying(3)
);


ALTER TABLE public.paises OWNER TO desarrollo_g;

--
-- TOC entry 1724 (class 1259 OID 30967)
-- Dependencies: 1723 7
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
-- TOC entry 2470 (class 0 OID 0)
-- Dependencies: 1724
-- Name: paises_id_pai_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE paises_id_pai_seq OWNED BY paises.id_pai;


--
-- TOC entry 2471 (class 0 OID 0)
-- Dependencies: 1724
-- Name: paises_id_pai_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('paises_id_pai_seq', 1, false);


--
-- TOC entry 1725 (class 1259 OID 30969)
-- Dependencies: 7
-- Name: parroquias; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE parroquias (
    id_par integer NOT NULL,
    des_par character varying(100),
    id_mun integer
);


ALTER TABLE public.parroquias OWNER TO desarrollo_g;

--
-- TOC entry 1726 (class 1259 OID 30972)
-- Dependencies: 1725 7
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
-- TOC entry 2472 (class 0 OID 0)
-- Dependencies: 1726
-- Name: parroquias_id_par_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE parroquias_id_par_seq OWNED BY parroquias.id_par;


--
-- TOC entry 2473 (class 0 OID 0)
-- Dependencies: 1726
-- Name: parroquias_id_par_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('parroquias_id_par_seq', 1, false);


SET default_tablespace = saib;

--
-- TOC entry 1727 (class 1259 OID 30974)
-- Dependencies: 7
-- Name: partes_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE partes_cuerpos (
    id_par_cue integer NOT NULL,
    nom_par_cue character varying(20)
);


ALTER TABLE public.partes_cuerpos OWNER TO desarrollo_g;

SET default_tablespace = '';

--
-- TOC entry 1728 (class 1259 OID 30977)
-- Dependencies: 7
-- Name: partes_cuerpos__categorias_cuerpos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE partes_cuerpos__categorias_cuerpos (
    id_par_cue_cat_cue integer NOT NULL,
    id_cat_cue integer NOT NULL,
    id_par_cue integer NOT NULL
);


ALTER TABLE public.partes_cuerpos__categorias_cuerpos OWNER TO desarrollo_g;

--
-- TOC entry 2474 (class 0 OID 0)
-- Dependencies: 1728
-- Name: TABLE partes_cuerpos__categorias_cuerpos; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON TABLE partes_cuerpos__categorias_cuerpos IS 'Permite seleccionar a que categoria pertenece la parte del cuerpo';


--
-- TOC entry 1729 (class 1259 OID 30980)
-- Dependencies: 1728 7
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
-- TOC entry 2475 (class 0 OID 0)
-- Dependencies: 1729
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq OWNED BY partes_cuerpos__categorias_cuerpos.id_par_cue_cat_cue;


--
-- TOC entry 2476 (class 0 OID 0)
-- Dependencies: 1729
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq', 9, true);


--
-- TOC entry 1730 (class 1259 OID 30982)
-- Dependencies: 1727 7
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
-- TOC entry 2477 (class 0 OID 0)
-- Dependencies: 1730
-- Name: partes_cuerpos_id_par_cue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE partes_cuerpos_id_par_cue_seq OWNED BY partes_cuerpos.id_par_cue;


--
-- TOC entry 2478 (class 0 OID 0)
-- Dependencies: 1730
-- Name: partes_cuerpos_id_par_cue_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('partes_cuerpos_id_par_cue_seq', 19, true);


--
-- TOC entry 1731 (class 1259 OID 30984)
-- Dependencies: 2077 7
-- Name: tiempo_evoluciones; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tiempo_evoluciones (
    id_tie_evo integer NOT NULL,
    id_his integer,
    tie_evo integer DEFAULT 0
);


ALTER TABLE public.tiempo_evoluciones OWNER TO desarrollo_g;

--
-- TOC entry 1732 (class 1259 OID 30988)
-- Dependencies: 7 1731
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
-- TOC entry 2479 (class 0 OID 0)
-- Dependencies: 1732
-- Name: tiempo_evoluciones_id_tie_evo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tiempo_evoluciones_id_tie_evo_seq OWNED BY tiempo_evoluciones.id_tie_evo;


--
-- TOC entry 2480 (class 0 OID 0)
-- Dependencies: 1732
-- Name: tiempo_evoluciones_id_tie_evo_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tiempo_evoluciones_id_tie_evo_seq', 5, true);


SET default_tablespace = saib;

--
-- TOC entry 1733 (class 1259 OID 30990)
-- Dependencies: 7
-- Name: tipos_consultas; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_consultas (
    id_tip_con integer NOT NULL,
    nom_tip_con character varying(50) NOT NULL
);


ALTER TABLE public.tipos_consultas OWNER TO desarrollo_g;

--
-- TOC entry 2481 (class 0 OID 0)
-- Dependencies: 1733
-- Name: COLUMN tipos_consultas.id_tip_con; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas.id_tip_con IS 'id tipos consultas';


--
-- TOC entry 1734 (class 1259 OID 30993)
-- Dependencies: 7 1733
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
-- TOC entry 2482 (class 0 OID 0)
-- Dependencies: 1734
-- Name: tipos_consultas_id_tip_con_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_consultas_id_tip_con_seq OWNED BY tipos_consultas.id_tip_con;


--
-- TOC entry 2483 (class 0 OID 0)
-- Dependencies: 1734
-- Name: tipos_consultas_id_tip_con_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_consultas_id_tip_con_seq', 9, true);


--
-- TOC entry 1735 (class 1259 OID 30995)
-- Dependencies: 7
-- Name: tipos_consultas_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_consultas_pacientes (
    id_tip_con_pac integer NOT NULL,
    id_tip_con integer NOT NULL,
    id_his integer NOT NULL,
    otr_tip_con character varying(100)
);


ALTER TABLE public.tipos_consultas_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2484 (class 0 OID 0)
-- Dependencies: 1735
-- Name: COLUMN tipos_consultas_pacientes.id_tip_con_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.id_tip_con_pac IS 'Id tipos de consulta paciente';


--
-- TOC entry 2485 (class 0 OID 0)
-- Dependencies: 1735
-- Name: COLUMN tipos_consultas_pacientes.id_tip_con; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.id_tip_con IS 'Id tipos de consulta';


--
-- TOC entry 2486 (class 0 OID 0)
-- Dependencies: 1735
-- Name: COLUMN tipos_consultas_pacientes.id_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.id_his IS 'Id historico';


--
-- TOC entry 2487 (class 0 OID 0)
-- Dependencies: 1735
-- Name: COLUMN tipos_consultas_pacientes.otr_tip_con; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tipos_consultas_pacientes.otr_tip_con IS 'Otro tipo de consulta';


--
-- TOC entry 1736 (class 1259 OID 30998)
-- Dependencies: 7 1735
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
-- TOC entry 2488 (class 0 OID 0)
-- Dependencies: 1736
-- Name: tipos_consultas_pacientes_id_tip_con_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_consultas_pacientes_id_tip_con_pac_seq OWNED BY tipos_consultas_pacientes.id_tip_con_pac;


--
-- TOC entry 2489 (class 0 OID 0)
-- Dependencies: 1736
-- Name: tipos_consultas_pacientes_id_tip_con_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_consultas_pacientes_id_tip_con_pac_seq', 186, true);


--
-- TOC entry 1737 (class 1259 OID 31000)
-- Dependencies: 7
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
-- TOC entry 1738 (class 1259 OID 31003)
-- Dependencies: 7 1737
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
-- TOC entry 2490 (class 0 OID 0)
-- Dependencies: 1738
-- Name: tipos_estudios_micologicos_id_tip_est_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_estudios_micologicos_id_tip_est_mic_seq OWNED BY tipos_estudios_micologicos.id_tip_est_mic;


--
-- TOC entry 2491 (class 0 OID 0)
-- Dependencies: 1738
-- Name: tipos_estudios_micologicos_id_tip_est_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_estudios_micologicos_id_tip_est_mic_seq', 62, true);


SET default_tablespace = '';

--
-- TOC entry 1739 (class 1259 OID 31005)
-- Dependencies: 7
-- Name: tipos_examenes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tipos_examenes (
    id_tip_exa integer NOT NULL,
    nom_tip_exa character varying(255)
);


ALTER TABLE public.tipos_examenes OWNER TO desarrollo_g;

--
-- TOC entry 1740 (class 1259 OID 31008)
-- Dependencies: 7 1739
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
-- TOC entry 2492 (class 0 OID 0)
-- Dependencies: 1740
-- Name: tipos_examenes_id_tip_exa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_examenes_id_tip_exa_seq OWNED BY tipos_examenes.id_tip_exa;


--
-- TOC entry 2493 (class 0 OID 0)
-- Dependencies: 1740
-- Name: tipos_examenes_id_tip_exa_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_examenes_id_tip_exa_seq', 3, false);


SET default_tablespace = saib;

--
-- TOC entry 1741 (class 1259 OID 31010)
-- Dependencies: 7
-- Name: tipos_micosis; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_micosis (
    id_tip_mic integer NOT NULL,
    nom_tip_mic character varying(20)
);


ALTER TABLE public.tipos_micosis OWNER TO desarrollo_g;

--
-- TOC entry 1742 (class 1259 OID 31013)
-- Dependencies: 7 1741
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
-- TOC entry 2494 (class 0 OID 0)
-- Dependencies: 1742
-- Name: tipos_micosis_id_tip_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_micosis_id_tip_mic_seq OWNED BY tipos_micosis.id_tip_mic;


--
-- TOC entry 2495 (class 0 OID 0)
-- Dependencies: 1742
-- Name: tipos_micosis_id_tip_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_micosis_id_tip_mic_seq', 4, false);


SET default_tablespace = '';

--
-- TOC entry 1743 (class 1259 OID 31015)
-- Dependencies: 7
-- Name: tipos_micosis_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tipos_micosis_pacientes (
    id_tip_mic_pac integer NOT NULL,
    id_tip_mic integer,
    id_his integer
);


ALTER TABLE public.tipos_micosis_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 1744 (class 1259 OID 31018)
-- Dependencies: 7
-- Name: tipos_micosis_pacientes__tipos_estudios_micologicos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE TABLE tipos_micosis_pacientes__tipos_estudios_micologicos (
    id_tip_mic_pac_tip_est_mic integer NOT NULL,
    id_tip_mic_pac integer,
    id_tip_est_mic integer
);


ALTER TABLE public.tipos_micosis_pacientes__tipos_estudios_micologicos OWNER TO desarrollo_g;

--
-- TOC entry 1745 (class 1259 OID 31021)
-- Dependencies: 7 1744
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
-- TOC entry 2496 (class 0 OID 0)
-- Dependencies: 1745
-- Name: tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq OWNED BY tipos_micosis_pacientes__tipos_estudios_micologicos.id_tip_mic_pac_tip_est_mic;


--
-- TOC entry 2497 (class 0 OID 0)
-- Dependencies: 1745
-- Name: tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq', 61, true);


--
-- TOC entry 1746 (class 1259 OID 31023)
-- Dependencies: 7 1743
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
-- TOC entry 2498 (class 0 OID 0)
-- Dependencies: 1746
-- Name: tipos_micosis_pacientes_id_tip_mic_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_micosis_pacientes_id_tip_mic_pac_seq OWNED BY tipos_micosis_pacientes.id_tip_mic_pac;


--
-- TOC entry 2499 (class 0 OID 0)
-- Dependencies: 1746
-- Name: tipos_micosis_pacientes_id_tip_mic_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_micosis_pacientes_id_tip_mic_pac_seq', 60, true);


SET default_tablespace = saib;

--
-- TOC entry 1747 (class 1259 OID 31025)
-- Dependencies: 7
-- Name: tipos_usuarios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tipos_usuarios (
    id_tip_usu integer NOT NULL,
    cod_tip_usu character varying(3) NOT NULL,
    des_tip_usu character varying(100)
);


ALTER TABLE public.tipos_usuarios OWNER TO desarrollo_g;

--
-- TOC entry 1748 (class 1259 OID 31028)
-- Dependencies: 7
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
-- TOC entry 1749 (class 1259 OID 31031)
-- Dependencies: 7 1748
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
-- TOC entry 2500 (class 0 OID 0)
-- Dependencies: 1749
-- Name: tipos_usuarios__usuarios_id_tip_usu_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_usuarios__usuarios_id_tip_usu_usu_seq OWNED BY tipos_usuarios__usuarios.id_tip_usu_usu;


--
-- TOC entry 2501 (class 0 OID 0)
-- Dependencies: 1749
-- Name: tipos_usuarios__usuarios_id_tip_usu_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_usuarios__usuarios_id_tip_usu_usu_seq', 52, true);


--
-- TOC entry 1750 (class 1259 OID 31033)
-- Dependencies: 7 1747
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
-- TOC entry 2502 (class 0 OID 0)
-- Dependencies: 1750
-- Name: tipos_usuarios_id_tip_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tipos_usuarios_id_tip_usu_seq OWNED BY tipos_usuarios.id_tip_usu;


--
-- TOC entry 2503 (class 0 OID 0)
-- Dependencies: 1750
-- Name: tipos_usuarios_id_tip_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tipos_usuarios_id_tip_usu_seq', 2, true);


--
-- TOC entry 1751 (class 1259 OID 31035)
-- Dependencies: 7
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
-- TOC entry 1752 (class 1259 OID 31038)
-- Dependencies: 7 1751
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
-- TOC entry 2504 (class 0 OID 0)
-- Dependencies: 1752
-- Name: transacciones_id_tip_tra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE transacciones_id_tip_tra_seq OWNED BY transacciones.id_tip_tra;


--
-- TOC entry 2505 (class 0 OID 0)
-- Dependencies: 1752
-- Name: transacciones_id_tip_tra_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('transacciones_id_tip_tra_seq', 16, true);


--
-- TOC entry 1753 (class 1259 OID 31040)
-- Dependencies: 7
-- Name: transacciones_usuarios; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE transacciones_usuarios (
    id_tip_tra integer NOT NULL,
    id_tip_usu_usu integer,
    id_tra_usu integer NOT NULL
);


ALTER TABLE public.transacciones_usuarios OWNER TO desarrollo_g;

--
-- TOC entry 1754 (class 1259 OID 31043)
-- Dependencies: 1753 7
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
-- TOC entry 2506 (class 0 OID 0)
-- Dependencies: 1754
-- Name: transacciones_usuarios_id_tra_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE transacciones_usuarios_id_tra_usu_seq OWNED BY transacciones_usuarios.id_tra_usu;


--
-- TOC entry 2507 (class 0 OID 0)
-- Dependencies: 1754
-- Name: transacciones_usuarios_id_tra_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('transacciones_usuarios_id_tra_usu_seq', 116, true);


--
-- TOC entry 1755 (class 1259 OID 31045)
-- Dependencies: 7
-- Name: tratamientos; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tratamientos (
    id_tra integer NOT NULL,
    nom_tra character varying(100)
);


ALTER TABLE public.tratamientos OWNER TO desarrollo_g;

--
-- TOC entry 1756 (class 1259 OID 31048)
-- Dependencies: 1755 7
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
-- TOC entry 2508 (class 0 OID 0)
-- Dependencies: 1756
-- Name: tratamientos_id_tra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tratamientos_id_tra_seq OWNED BY tratamientos.id_tra;


--
-- TOC entry 2509 (class 0 OID 0)
-- Dependencies: 1756
-- Name: tratamientos_id_tra_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tratamientos_id_tra_seq', 1, false);


--
-- TOC entry 1757 (class 1259 OID 31050)
-- Dependencies: 7
-- Name: tratamientos_pacientes; Type: TABLE; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE TABLE tratamientos_pacientes (
    id_tra_pac integer NOT NULL,
    id_his integer NOT NULL,
    id_tra integer NOT NULL,
    otr_tra character varying(100)
);


ALTER TABLE public.tratamientos_pacientes OWNER TO desarrollo_g;

--
-- TOC entry 2510 (class 0 OID 0)
-- Dependencies: 1757
-- Name: COLUMN tratamientos_pacientes.id_tra_pac; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.id_tra_pac IS 'Id transaccion paciente';


--
-- TOC entry 2511 (class 0 OID 0)
-- Dependencies: 1757
-- Name: COLUMN tratamientos_pacientes.id_his; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.id_his IS 'Id historico';


--
-- TOC entry 2512 (class 0 OID 0)
-- Dependencies: 1757
-- Name: COLUMN tratamientos_pacientes.id_tra; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.id_tra IS 'Id tratamiento';


--
-- TOC entry 2513 (class 0 OID 0)
-- Dependencies: 1757
-- Name: COLUMN tratamientos_pacientes.otr_tra; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN tratamientos_pacientes.otr_tra IS 'Otro tratamiento';


--
-- TOC entry 1758 (class 1259 OID 31053)
-- Dependencies: 7 1757
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
-- TOC entry 2514 (class 0 OID 0)
-- Dependencies: 1758
-- Name: tratamientos_pacientes_id_tra_pac_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE tratamientos_pacientes_id_tra_pac_seq OWNED BY tratamientos_pacientes.id_tra_pac;


--
-- TOC entry 2515 (class 0 OID 0)
-- Dependencies: 1758
-- Name: tratamientos_pacientes_id_tra_pac_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('tratamientos_pacientes_id_tra_pac_seq', 247, true);


--
-- TOC entry 1759 (class 1259 OID 31055)
-- Dependencies: 2092 7
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
-- TOC entry 2516 (class 0 OID 0)
-- Dependencies: 1759
-- Name: COLUMN usuarios_administrativos.fec_reg_usu_adm; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN usuarios_administrativos.fec_reg_usu_adm IS 'Fecha de registro de los usuarios';


--
-- TOC entry 2517 (class 0 OID 0)
-- Dependencies: 1759
-- Name: COLUMN usuarios_administrativos.adm_usu; Type: COMMENT; Schema: public; Owner: desarrollo_g
--

COMMENT ON COLUMN usuarios_administrativos.adm_usu IS '
	TRUE: si es un super usuario
	FALSE: si es usuario com limitaciones
';


--
-- TOC entry 1760 (class 1259 OID 31059)
-- Dependencies: 1759 7
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
-- TOC entry 2518 (class 0 OID 0)
-- Dependencies: 1760
-- Name: usuarios_administrativos_id_usu_adm_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: desarrollo_g
--

ALTER SEQUENCE usuarios_administrativos_id_usu_adm_seq OWNED BY usuarios_administrativos.id_usu_adm;


--
-- TOC entry 2519 (class 0 OID 0)
-- Dependencies: 1760
-- Name: usuarios_administrativos_id_usu_adm_seq; Type: SEQUENCE SET; Schema: public; Owner: desarrollo_g
--

SELECT pg_catalog.setval('usuarios_administrativos_id_usu_adm_seq', 23, true);


--
-- TOC entry 1761 (class 1259 OID 31061)
-- Dependencies: 1850 7
-- Name: view_auditoria_transacciones; Type: VIEW; Schema: public; Owner: desarrollo_g
--

CREATE VIEW view_auditoria_transacciones AS
    SELECT to_char(at.fec_aud_tra, 'DD/MM/YYYY HH12:MI:SS AM'::text) AS fecha_tran, (((d.nom_doc)::text || ' '::text) || (d.ape_doc)::text) AS nom_ape_usu, d.log_doc AS log_usu, CASE WHEN (at.data_xml IS NOT NULL) THEN 'Si'::text ELSE 'No'::text END AS detalle, at.id_tip_usu_usu, at.data_xml, at.id_tip_tra, t.cod_tip_tra, t.id_mod FROM (((auditoria_transacciones at LEFT JOIN transacciones t USING (id_tip_tra)) LEFT JOIN tipos_usuarios__usuarios tuu USING (id_tip_usu_usu)) LEFT JOIN doctores d ON ((tuu.id_doc = d.id_doc))) ORDER BY to_char(at.fec_aud_tra, 'DD/MM/YYYY HH12:MI:SS AM'::text) DESC;


ALTER TABLE public.view_auditoria_transacciones OWNER TO desarrollo_g;

--
-- TOC entry 1762 (class 1259 OID 31066)
-- Dependencies: 1851 7
-- Name: view_tipo_enfermedades_mic_pac; Type: VIEW; Schema: public; Owner: desarrollo_g
--

CREATE VIEW view_tipo_enfermedades_mic_pac AS
    SELECT hp.id_his, to_char(hp.fec_his, 'DD/MM/YYYY HH12:MI:SS AM'::text) AS fec_his, tm.id_tip_mic, tm.nom_tip_mic, hp.id_pac, (hp.id_his)::text AS num_his FROM ((tipos_micosis tm LEFT JOIN tipos_micosis_pacientes tmp USING (id_tip_mic)) LEFT JOIN historiales_pacientes hp ON ((tmp.id_his = hp.id_his))) WHERE (hp.id_his IS NOT NULL) ORDER BY tm.nom_tip_mic;


ALTER TABLE public.view_tipo_enfermedades_mic_pac OWNER TO desarrollo_g;

SET search_path = saib_model, pg_catalog;

SET default_tablespace = '';

--
-- TOC entry 1763 (class 1259 OID 31070)
-- Dependencies: 6
-- Name: wwwsqldesigner; Type: TABLE; Schema: saib_model; Owner: postgres; Tablespace: 
--

CREATE TABLE wwwsqldesigner (
    keyword character varying(30) NOT NULL,
    xmldata text,
    dt timestamp without time zone
);


ALTER TABLE saib_model.wwwsqldesigner OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 2043 (class 2604 OID 31076)
-- Dependencies: 1670 1669
-- Name: id_ani; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE animales ALTER COLUMN id_ani SET DEFAULT nextval('animales_id_ani_seq'::regclass);


--
-- TOC entry 2044 (class 2604 OID 31077)
-- Dependencies: 1672 1671
-- Name: id_ant_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE antecedentes_pacientes ALTER COLUMN id_ant_pac SET DEFAULT nextval('antecedentes_pacientes_id_ant_pac_seq'::regclass);


--
-- TOC entry 2045 (class 2604 OID 31078)
-- Dependencies: 1674 1673
-- Name: id_ant_per; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE antecedentes_personales ALTER COLUMN id_ant_per SET DEFAULT nextval('antecedentes_personales_id_ant_per_seq'::regclass);


--
-- TOC entry 2046 (class 2604 OID 31079)
-- Dependencies: 1676 1675
-- Name: id_aud_tra; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE auditoria_transacciones ALTER COLUMN id_aud_tra SET DEFAULT nextval('auditoria_transacciones_id_aud_tra_seq'::regclass);


--
-- TOC entry 2047 (class 2604 OID 31080)
-- Dependencies: 1678 1677
-- Name: id_cat_cue_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE categorias__cuerpos_micosis ALTER COLUMN id_cat_cue_mic SET DEFAULT nextval('categorias__cuerpos_micosis_id_cat_cue_mic_seq'::regclass);


--
-- TOC entry 2048 (class 2604 OID 31081)
-- Dependencies: 1681 1679
-- Name: id_cat_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE categorias_cuerpos ALTER COLUMN id_cat_cue SET DEFAULT nextval('categorias_cuerpos_id_cat_cue_seq'::regclass);


--
-- TOC entry 2049 (class 2604 OID 31082)
-- Dependencies: 1707 1680
-- Name: id_cat_cue_les; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE categorias_cuerpos__lesiones ALTER COLUMN id_cat_cue_les SET DEFAULT nextval('lesiones__partes_cuerpos_id_les_par_cue_seq'::regclass);


--
-- TOC entry 2050 (class 2604 OID 31083)
-- Dependencies: 1683 1682
-- Name: id_cen_sal_doc; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE centro_salud_doctores ALTER COLUMN id_cen_sal_doc SET DEFAULT nextval('centro_salud_doctores_id_cen_sal_doc_seq'::regclass);


--
-- TOC entry 2052 (class 2604 OID 31084)
-- Dependencies: 1687 1686
-- Name: id_cen_sal_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE centro_salud_pacientes ALTER COLUMN id_cen_sal_pac SET DEFAULT nextval('centro_salud_pacientes_id_cen_sal_pac_seq'::regclass);


--
-- TOC entry 2051 (class 2604 OID 31085)
-- Dependencies: 1685 1684
-- Name: id_cen_sal; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE centro_saluds ALTER COLUMN id_cen_sal SET DEFAULT nextval('centro_salud_id_cen_sal_seq'::regclass);


--
-- TOC entry 2053 (class 2604 OID 31086)
-- Dependencies: 1689 1688
-- Name: id_con_ani; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE contactos_animales ALTER COLUMN id_con_ani SET DEFAULT nextval('contactos_animales_id_con_ani_seq'::regclass);


--
-- TOC entry 2055 (class 2604 OID 31087)
-- Dependencies: 1691 1690
-- Name: id_doc; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE doctores ALTER COLUMN id_doc SET DEFAULT nextval('doctores_id_doc_seq'::regclass);


--
-- TOC entry 2056 (class 2604 OID 31088)
-- Dependencies: 1693 1692
-- Name: id_enf_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE enfermedades_micologicas ALTER COLUMN id_enf_mic SET DEFAULT nextval('enfermedades_micologicas_id_enf_mic_seq'::regclass);


--
-- TOC entry 2057 (class 2604 OID 31089)
-- Dependencies: 1695 1694
-- Name: id_enf_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE enfermedades_pacientes ALTER COLUMN id_enf_pac SET DEFAULT nextval('enfermedades_pacientes_id_enf_pac_seq'::regclass);


--
-- TOC entry 2058 (class 2604 OID 31090)
-- Dependencies: 1697 1696
-- Name: id_est; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE estados ALTER COLUMN id_est SET DEFAULT nextval('estados_id_est_seq'::regclass);


--
-- TOC entry 2059 (class 2604 OID 31091)
-- Dependencies: 1703 1698
-- Name: id_for_inf; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE forma_infecciones ALTER COLUMN id_for_inf SET DEFAULT nextval('forma_infecciones_id_for_inf_seq'::regclass);


--
-- TOC entry 2060 (class 2604 OID 31092)
-- Dependencies: 1700 1699
-- Name: id_for_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE forma_infecciones__pacientes ALTER COLUMN id_for_pac SET DEFAULT nextval('forma_infecciones__pacientes_id_for_pac_seq'::regclass);


--
-- TOC entry 2061 (class 2604 OID 31093)
-- Dependencies: 1702 1701
-- Name: id_for_inf_tip_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE forma_infecciones__tipos_micosis ALTER COLUMN id_for_inf_tip_mic SET DEFAULT nextval('forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq'::regclass);


--
-- TOC entry 2063 (class 2604 OID 31094)
-- Dependencies: 1705 1704
-- Name: id_his; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE historiales_pacientes ALTER COLUMN id_his SET DEFAULT nextval('historiales_pacientes_id_his_seq'::regclass);


--
-- TOC entry 2064 (class 2604 OID 31095)
-- Dependencies: 1708 1706
-- Name: id_les; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE lesiones ALTER COLUMN id_les SET DEFAULT nextval('lesiones_id_les_seq'::regclass);


--
-- TOC entry 2065 (class 2604 OID 31096)
-- Dependencies: 1710 1709
-- Name: id_les_par_cue_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE lesiones_partes_cuerpos__pacientes ALTER COLUMN id_les_par_cue_pac SET DEFAULT nextval('lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq'::regclass);


--
-- TOC entry 2066 (class 2604 OID 31097)
-- Dependencies: 1712 1711
-- Name: id_loc_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE localizaciones_cuerpos ALTER COLUMN id_loc_cue SET DEFAULT nextval('localizaciones_cuerpos_id_loc_cue_seq'::regclass);


--
-- TOC entry 2067 (class 2604 OID 31098)
-- Dependencies: 1714 1713
-- Name: id_mod; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE modulos ALTER COLUMN id_mod SET DEFAULT nextval('modulos_id_mod_seq'::regclass);


--
-- TOC entry 2068 (class 2604 OID 31099)
-- Dependencies: 1716 1715
-- Name: id_mue_cli; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE muestras_clinicas ALTER COLUMN id_mue_cli SET DEFAULT nextval('muestras_clinicas_id_mue_cli_seq'::regclass);


--
-- TOC entry 2069 (class 2604 OID 31100)
-- Dependencies: 1718 1717
-- Name: id_mue_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE muestras_pacientes ALTER COLUMN id_mue_pac SET DEFAULT nextval('muestras_pacientes_id_mue_pac_seq'::regclass);


--
-- TOC entry 2070 (class 2604 OID 31101)
-- Dependencies: 1720 1719
-- Name: id_mun; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE municipios ALTER COLUMN id_mun SET DEFAULT nextval('municipios_id_mun_seq'::regclass);


--
-- TOC entry 2072 (class 2604 OID 31102)
-- Dependencies: 1722 1721
-- Name: id_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE pacientes ALTER COLUMN id_pac SET DEFAULT nextval('pacientes_id_pac_seq'::regclass);


--
-- TOC entry 2073 (class 2604 OID 31103)
-- Dependencies: 1724 1723
-- Name: id_pai; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE paises ALTER COLUMN id_pai SET DEFAULT nextval('paises_id_pai_seq'::regclass);


--
-- TOC entry 2074 (class 2604 OID 31104)
-- Dependencies: 1726 1725
-- Name: id_par; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE parroquias ALTER COLUMN id_par SET DEFAULT nextval('parroquias_id_par_seq'::regclass);


--
-- TOC entry 2075 (class 2604 OID 31105)
-- Dependencies: 1730 1727
-- Name: id_par_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE partes_cuerpos ALTER COLUMN id_par_cue SET DEFAULT nextval('partes_cuerpos_id_par_cue_seq'::regclass);


--
-- TOC entry 2076 (class 2604 OID 31106)
-- Dependencies: 1729 1728
-- Name: id_par_cue_cat_cue; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE partes_cuerpos__categorias_cuerpos ALTER COLUMN id_par_cue_cat_cue SET DEFAULT nextval('partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 31107)
-- Dependencies: 1732 1731
-- Name: id_tie_evo; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tiempo_evoluciones ALTER COLUMN id_tie_evo SET DEFAULT nextval('tiempo_evoluciones_id_tie_evo_seq'::regclass);


--
-- TOC entry 2079 (class 2604 OID 31108)
-- Dependencies: 1734 1733
-- Name: id_tip_con; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_consultas ALTER COLUMN id_tip_con SET DEFAULT nextval('tipos_consultas_id_tip_con_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 31109)
-- Dependencies: 1736 1735
-- Name: id_tip_con_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_consultas_pacientes ALTER COLUMN id_tip_con_pac SET DEFAULT nextval('tipos_consultas_pacientes_id_tip_con_pac_seq'::regclass);


--
-- TOC entry 2081 (class 2604 OID 31110)
-- Dependencies: 1738 1737
-- Name: id_tip_est_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_estudios_micologicos ALTER COLUMN id_tip_est_mic SET DEFAULT nextval('tipos_estudios_micologicos_id_tip_est_mic_seq'::regclass);


--
-- TOC entry 2082 (class 2604 OID 31111)
-- Dependencies: 1740 1739
-- Name: id_tip_exa; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_examenes ALTER COLUMN id_tip_exa SET DEFAULT nextval('tipos_examenes_id_tip_exa_seq'::regclass);


--
-- TOC entry 2083 (class 2604 OID 31112)
-- Dependencies: 1742 1741
-- Name: id_tip_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_micosis ALTER COLUMN id_tip_mic SET DEFAULT nextval('tipos_micosis_id_tip_mic_seq'::regclass);


--
-- TOC entry 2084 (class 2604 OID 31113)
-- Dependencies: 1746 1743
-- Name: id_tip_mic_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_micosis_pacientes ALTER COLUMN id_tip_mic_pac SET DEFAULT nextval('tipos_micosis_pacientes_id_tip_mic_pac_seq'::regclass);


--
-- TOC entry 2085 (class 2604 OID 31114)
-- Dependencies: 1745 1744
-- Name: id_tip_mic_pac_tip_est_mic; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_micosis_pacientes__tipos_estudios_micologicos ALTER COLUMN id_tip_mic_pac_tip_est_mic SET DEFAULT nextval('tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq'::regclass);


--
-- TOC entry 2086 (class 2604 OID 31115)
-- Dependencies: 1750 1747
-- Name: id_tip_usu; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_usuarios ALTER COLUMN id_tip_usu SET DEFAULT nextval('tipos_usuarios_id_tip_usu_seq'::regclass);


--
-- TOC entry 2087 (class 2604 OID 31116)
-- Dependencies: 1749 1748
-- Name: id_tip_usu_usu; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tipos_usuarios__usuarios ALTER COLUMN id_tip_usu_usu SET DEFAULT nextval('tipos_usuarios__usuarios_id_tip_usu_usu_seq'::regclass);


--
-- TOC entry 2088 (class 2604 OID 31117)
-- Dependencies: 1752 1751
-- Name: id_tip_tra; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE transacciones ALTER COLUMN id_tip_tra SET DEFAULT nextval('transacciones_id_tip_tra_seq'::regclass);


--
-- TOC entry 2089 (class 2604 OID 31118)
-- Dependencies: 1754 1753
-- Name: id_tra_usu; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE transacciones_usuarios ALTER COLUMN id_tra_usu SET DEFAULT nextval('transacciones_usuarios_id_tra_usu_seq'::regclass);


--
-- TOC entry 2090 (class 2604 OID 31119)
-- Dependencies: 1756 1755
-- Name: id_tra; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tratamientos ALTER COLUMN id_tra SET DEFAULT nextval('tratamientos_id_tra_seq'::regclass);


--
-- TOC entry 2091 (class 2604 OID 31120)
-- Dependencies: 1758 1757
-- Name: id_tra_pac; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE tratamientos_pacientes ALTER COLUMN id_tra_pac SET DEFAULT nextval('tratamientos_pacientes_id_tra_pac_seq'::regclass);


--
-- TOC entry 2093 (class 2604 OID 31121)
-- Dependencies: 1760 1759
-- Name: id_usu_adm; Type: DEFAULT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE usuarios_administrativos ALTER COLUMN id_usu_adm SET DEFAULT nextval('usuarios_administrativos_id_usu_adm_seq'::regclass);


--
-- TOC entry 2310 (class 0 OID 30817)
-- Dependencies: 1669
-- Data for Name: animales; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY animales (id_ani, nom_ani) FROM stdin;
1	Perro
2	Gato
3	Aves
4	Animales de Corral
5	Otros
\.


--
-- TOC entry 2311 (class 0 OID 30822)
-- Dependencies: 1671
-- Data for Name: antecedentes_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY antecedentes_pacientes (id_ant_pac, id_ant_per, id_pac) FROM stdin;
18	2	27
19	3	27
25	1	13
35	2	7
36	3	7
37	4	7
38	9	7
39	11	7
40	12	7
\.


--
-- TOC entry 2312 (class 0 OID 30827)
-- Dependencies: 1673
-- Data for Name: antecedentes_personales; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY antecedentes_personales (id_ant_per, nom_ant_per) FROM stdin;
1	Ninguna
2	Obesidad
3	Diabetes
4	Traumatismo
5	Cirugía
6	HIV/SIDA
7	Cáncer
8	inmunosupresión/Neutropenia
9	Uso Esteroides
10	Embarazo
11	Neoplasias
12	Inanición
13	Otros
\.


--
-- TOC entry 2313 (class 0 OID 30832)
-- Dependencies: 1675
-- Data for Name: auditoria_transacciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY auditoria_transacciones (id_aud_tra, fec_aud_tra, id_tip_usu_usu, id_tip_tra, data_xml) FROM stdin;
1	2011-08-28 18:16:18.03	17	10	<?xml version="1.0" standalone="yes"?><modificacion_de_pacientes>\n\t\t\t\t <tabla nombre="pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Fecha Nacimiento"><actual>2011-09-06</actual><anterior>2011-09-06</anterior></campo><campo nombre="Nacionalidad"><actual>Venezolano</actual><anterior>Venezolano</anterior></campo><campo nombre="Teléfono Habitación"><actual>3622824</actual><anterior>3622824</anterior></campo><campo nombre="Teléfono Célular"><actual>04265168824</actual><anterior>04265168824</anterior></campo><campo nombre="Ocupación"><actual>Técnico</actual><anterior>Técnico</anterior></campo><campo nombre="País"><actual>Venezuela</actual><anterior>Venezuela</anterior></campo><campo nombre="Estado"><actual>Distrito Capital</actual><anterior>Distrito Capital</anterior></campo><campo nombre="Municipio"><actual>\tLibertador Caracas\t\t </actual><anterior>\tLibertador Caracas\t\t </anterior></campo><campo nombre="Ciudad"><actual>Guarenas</actual><anterior>Guarenas</anterior></campo></tabla><tabla nombre="antecedentes_personales"><campo nombre="Antecedentes Personales"><actual>Uso Esteroides ,Neoplasias ,Inanición </actual><anterior>Uso Esteroides ,Neoplasias ,Inanición </anterior></campo></tabla></modificacion_de_pacientes>
2	2011-09-04 11:30:11.606	17	14	<?xml version="1.0" standalone="yes"?><eliminacion_del_historial_paciente>\n\t\t\t <tabla nombre="historiales_pacientes"><campo nombre="Nombre Paciente"><actual>ninguno</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido Paciente"><actual>ninguno</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula Paciente"><actual>ninguno</actual><anterior>17651233</anterior></campo><campo nombre="Descripción de la Historia"><actual>ninguno</actual><anterior></anterior></campo><campo nombre="Descripción Adicional"><actual>ninguno</actual><anterior></anterior></campo><campo nombre="Fecha de Historia"><actual>ninguno</actual><anterior>2011-07-08 12:11:11.417-04:30</anterior></campo></tabla></eliminacion_del_historial_paciente>
3	2011-09-11 17:10:18.105	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
4	2011-11-02 22:57:44.609	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
5	2011-11-02 22:59:25.293	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
6	2011-11-02 22:59:46.128	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
7	2011-11-02 22:59:50.854	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
17	2011-11-16 08:16:22.776	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Pediatria ,urologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I</anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Pediatria ,urologia</actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Pediatria ,urologiaCitotóxicos ,Glucorticoides </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro Citotóxicos ,Glucorticoides </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>5</actual><anterior>5</anterior></campo></tabla></Información_adicional>
8	2011-11-06 21:49:49.907	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
9	2011-11-06 22:30:55.296	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
10	2011-11-06 22:41:12.072	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
11	2011-11-06 23:25:18.039	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
12	2011-11-06 23:25:21.92	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
13	2011-11-06 23:25:53.843	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
14	2011-11-16 08:12:59.528	17	10	<?xml version="1.0" standalone="yes"?><modificacion_de_pacientes>\n\t\t\t\t <tabla nombre="pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Fecha Nacimiento"><actual>2011-09-06</actual><anterior>2011-09-06</anterior></campo><campo nombre="Sexo"><actual>F</actual><anterior>F</anterior></campo><campo nombre="Nacionalidad"><actual>Venezolano</actual><anterior>Venezolano</anterior></campo><campo nombre="Teléfono Habitación"><actual>3622824</actual><anterior>3622824</anterior></campo><campo nombre="Teléfono Célular"><actual>04265168824</actual><anterior>04265168824</anterior></campo><campo nombre="Ocupación"><actual>Técnico</actual><anterior>Técnico</anterior></campo><campo nombre="País"><actual>Venezuela</actual><anterior>Venezuela</anterior></campo><campo nombre="Estado"><actual>Distrito Capital</actual><anterior>Distrito Capital</anterior></campo><campo nombre="Municipio"><actual>\tLibertador Caracas\t\t </actual><anterior>\tLibertador Caracas\t\t </anterior></campo><campo nombre="Ciudad"><actual>Guarenas</actual><anterior>Guarenas</anterior></campo></tabla><tabla nombre="antecedentes_personales"><campo nombre="Antecedentes Personales"><actual>Obesidad ,Diabetes ,Traumatismo ,Uso Esteroides ,Neoplasias ,Inanición </actual><anterior>Uso Esteroides ,Neoplasias ,Inanición </anterior></campo></tabla></modificacion_de_pacientes>
15	2011-11-16 08:15:57.618	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Rural </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I</actual><anterior>Ambulatorio Rural</anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro </actual><anterior>Ambulatorio Rura</anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro</actual><anterior>Ambulatorio Rur</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>5</actual><anterior>5</anterior></campo></tabla></Información_adicional>
16	2011-11-16 08:16:11.188	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I</actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I</anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro Citotóxicos ,Glucorticoides </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>5</actual><anterior>5</anterior></campo></tabla></Información_adicional>
18	2011-11-16 08:28:01.434	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
19	2011-11-16 08:28:26.924	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
20	2011-11-16 08:31:55.499	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>10</actual><anterior>10</anterior></campo></tabla></Información_adicional>
21	2011-11-16 08:32:09.104	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>12</actual><anterior>10</anterior></campo></tabla></Información_adicional>
22	2011-11-16 16:01:40.948	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
23	2011-11-16 16:01:49.432	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
24	2011-11-16 16:01:58.618	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
25	2011-11-16 16:02:13.733	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
26	2011-11-16 16:02:22.528	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
27	2011-11-16 16:02:39.045	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>12</anterior></campo></tabla></Información_adicional>
28	2011-11-16 16:09:17.079	17	10	<?xml version="1.0" standalone="yes"?><modificacion_de_pacientes>\n\t\t\t\t <tabla nombre="pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Fecha Nacimiento"><actual>2011-09-06</actual><anterior>2011-09-06</anterior></campo><campo nombre="Sexo"><actual>F</actual><anterior>F</anterior></campo><campo nombre="Nacionalidad"><actual>Venezolano</actual><anterior>Venezolano</anterior></campo><campo nombre="Teléfono Habitación"><actual>3622824</actual><anterior>3622824</anterior></campo><campo nombre="Teléfono Célular"><actual>04265168824</actual><anterior>04265168824</anterior></campo><campo nombre="Ocupación"><actual>Técnico</actual><anterior>Técnico</anterior></campo><campo nombre="País"><actual>Venezuela</actual><anterior>Venezuela</anterior></campo><campo nombre="Estado"><actual>Yaracuy</actual><anterior>Distrito Capital</anterior></campo><campo nombre="Municipio"><actual>\tCocorote\t\t </actual><anterior>\tLibertador Caracas\t\t </anterior></campo><campo nombre="Ciudad"><actual>Guarenas</actual><anterior>Guarenas</anterior></campo></tabla><tabla nombre="antecedentes_personales"><campo nombre="Antecedentes Personales"><actual>Obesidad ,Diabetes ,Traumatismo ,Uso Esteroides ,Neoplasias ,Inanición </actual><anterior>Obesidad ,Diabetes ,Traumatismo ,Uso Esteroides ,Neoplasias ,Inanición </anterior></campo></tabla></modificacion_de_pacientes>
29	2011-11-16 16:16:51.944	17	13	<?xml version="1.0" standalone="yes"?><modificacion_del_historial_paciente>\n\t\t <tabla nombre="historiales_pacientes"><campo nombre="Nombre Paciente"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido Paciente"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula Paciente"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Descripción de la Historia"><actual>Prueba del historial de los pacientes para que se puedan registrar las enfermedades que se muestran en la aplicacion, un paciente puede tener una serie de enfermedades por lo que es necesario la creacion de un modulo que permita gestionar,</actual><anterior>demops</anterior></campo><campo nombre="Descripción Adicional"><actual>Gestionar de forma permanente las enfermedades que el paciente puede padecer a lo largo del periodo de tiempo, si el paciente se cura encontes ese historial queda descartado, y se procede a abrir un nuevo historico para el paciente que permita dicho.</actual><anterior>demos</anterior></campo><campo nombre="Fecha de Historia"><actual>2011-07-24 09:39:20.062-04:30</actual><anterior>2011-07-24 09:39:20.062-04:30</anterior></campo></tabla></modificacion_del_historial_paciente>
30	2011-11-16 16:19:51.588	17	12	<?xml version="1.0" standalone="yes"?><registro_del_historial_paciente>\n\t\t <tabla nombre="historiales_pacientes"><campo nombre="Nombre Paciente"><actual>Mary</actual><anterior>ninguno</anterior></campo><campo nombre="Apellido Paciente"><actual>Wester</actual><anterior>ninguno</anterior></campo><campo nombre="Cédula Paciente"><actual>8752299</actual><anterior>ninguno</anterior></campo><campo nombre="Descripción de la Historia"><actual>Enfermedad prueba</actual><anterior>ninguno</anterior></campo><campo nombre="Descripción Adicional"><actual>Enfermedad prueba</actual><anterior>ninguno</anterior></campo><campo nombre="Fecha de Historia"><actual>2011-11-16 16:19:51.588-04:30</actual><anterior>ninguno</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Tiempo de Evolución"><actual>5</actual><anterior>ninguno</anterior></campo></tabla></registro_del_historial_paciente>
31	2011-11-16 16:23:23.979	17	11	<?xml version="1.0" standalone="yes"?><eliminacion_de_pacientes>\n\t\t\t\t <tabla nombre="pacientes"><campo nombre="ID"><actual>ninguno</actual><anterior>28</anterior></campo><campo nombre="Nombre"><actual>ninguno</actual><anterior>demo</anterior></campo><campo nombre="Apellido"><actual>ninguno</actual><anterior>sdf</anterior></campo><campo nombre="Cédula"><actual>ninguno</actual><anterior>12345</anterior></campo><campo nombre="Fecha Nacimiento"><actual>ninguno</actual><anterior>2011-07-27</anterior></campo><campo nombre="Nacionalidad"><actual>ninguno</actual><anterior>Venezolano</anterior></campo><campo nombre="Teléfono Habitación"><actual>ninguno</actual><anterior>3622222</anterior></campo><campo nombre="Teléfono Célular"><actual>ninguno</actual><anterior>17302857</anterior></campo><campo nombre="Ocupación"><actual>ninguno</actual><anterior>Técnico</anterior></campo><campo nombre="País"><actual>ninguno</actual><anterior>ninguno</anterior></campo><campo nombre="Estado"><actual>ninguno</actual><anterior>ninguno</anterior></campo><campo nombre="Municipio"><actual>ninguno</actual><anterior>ninguno</anterior></campo><campo nombre="Ciudad"><actual>ninguno</actual><anterior>Guarenas</anterior></campo></tabla><tabla nombre="antecedentes_pacientes"><campo nombre="Antecedentes Personales"><actual>ninguno</actual><anterior>Obesidad ,Diabetes </anterior></campo></tabla></eliminacion_de_pacientes>
52	2011-12-25 10:20:27.593	49	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
32	2011-11-16 16:24:29.327	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior></anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I</actual><anterior></anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro IAves </actual><anterior></anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro IAves</actual><anterior></anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>60</actual><anterior>0</anterior></campo></tabla></Información_adicional>
33	2011-11-16 16:24:41.348	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I</actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I</anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro IAves </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro IAves </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro IAves</actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro IAves</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>1600</actual><anterior>60</anterior></campo></tabla></Información_adicional>
34	2011-11-16 16:24:49.149	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I</anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro IAves </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves</actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro IAves</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>1600</actual><anterior>1600</anterior></campo></tabla></Información_adicional>
35	2011-11-16 16:24:53.225	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves Citotóxicos ,Glucorticoides </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>1600</actual><anterior>1600</anterior></campo></tabla></Información_adicional>
36	2011-11-16 16:27:53.176	17	12	<?xml version="1.0" standalone="yes"?><registro_del_historial_paciente>\n\t\t <tabla nombre="historiales_pacientes"><campo nombre="Nombre Paciente"><actual>demo</actual><anterior>ninguno</anterior></campo><campo nombre="Apellido Paciente"><actual>asd</actual><anterior>ninguno</anterior></campo><campo nombre="Cédula Paciente"><actual>1234</actual><anterior>ninguno</anterior></campo><campo nombre="Descripción de la Historia"><actual>demostracion de historial</actual><anterior>ninguno</anterior></campo><campo nombre="Descripción Adicional"><actual>demostracion del historial</actual><anterior>ninguno</anterior></campo><campo nombre="Fecha de Historia"><actual>2011-11-16 16:27:53.176-04:30</actual><anterior>ninguno</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Tiempo de Evolución"><actual>5</actual><anterior>ninguno</anterior></campo></tabla></registro_del_historial_paciente>
37	2011-11-16 16:29:11.01	17	12	<?xml version="1.0" standalone="yes"?><registro_del_historial_paciente>\n\t\t <tabla nombre="historiales_pacientes"><campo nombre="Nombre Paciente"><actual>Gisela </actual><anterior>ninguno</anterior></campo><campo nombre="Apellido Paciente"><actual>Contreras</actual><anterior>ninguno</anterior></campo><campo nombre="Cédula Paciente"><actual>13456094</actual><anterior>ninguno</anterior></campo><campo nombre="Descripción de la Historia"><actual>prototypo</actual><anterior>ninguno</anterior></campo><campo nombre="Descripción Adicional"><actual>Prototypo</actual><anterior>ninguno</anterior></campo><campo nombre="Fecha de Historia"><actual>2011-11-16 16:29:11.01-04:30</actual><anterior>ninguno</anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Tiempo de Evolución"><actual>5</actual><anterior>ninguno</anterior></campo></tabla></registro_del_historial_paciente>
38	2011-11-16 16:31:14.86	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Gisela </actual><anterior>Gisela </anterior></campo><campo nombre="Apellido"><actual>Contreras</actual><anterior>Contreras</anterior></campo><campo nombre="Cédula"><actual>13456094</actual><anterior>13456094</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
54	2011-12-25 11:03:56.178	49	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
39	2011-11-16 16:31:34.395	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves Citotóxicos ,Glucorticoides ,Otros ,Radioterapia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves Citotóxicos ,Glucorticoides </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>1600</actual><anterior>1600</anterior></campo></tabla></Información_adicional>
40	2011-11-16 16:31:48.354	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Gisela </actual><anterior>Gisela </anterior></campo><campo nombre="Apellido"><actual>Contreras</actual><anterior>Contreras</anterior></campo><campo nombre="Cédula"><actual>13456094</actual><anterior>13456094</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
41	2011-11-16 16:33:10.135	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves Citotóxicos ,Glucorticoides ,Otros ,Radioterapia </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia Aves Citotóxicos ,Glucorticoides ,Otros ,Radioterapia </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>1600</actual><anterior>1600</anterior></campo></tabla></Información_adicional>
42	2011-11-16 16:34:33.723	17	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
43	2011-12-14 20:24:34.344	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
53	2011-12-25 10:21:26.199	49	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica ,Otros Consulta ,Consulta Interna ,Dermatologia ,Geriatria ,Otros Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
55	2011-12-25 11:06:38.612	49	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
56	2011-12-25 11:06:56.736	49	15	<?xml version="1.0" standalone="yes"?><registrar_muestra_clínica_paciente>\n\t\t\t <tabla nombre="muestras_pacientes"><campo nombre="Nombre"><actual>Adriana</actual><anterior>Adriana</anterior></campo><campo nombre="Apellido"><actual>Lozada</actual><anterior>Lozada</anterior></campo><campo nombre="Cédula"><actual>17651233</actual><anterior>17651233</anterior></campo><campo nombre="Muestra Clínica"><actual>ninguno</actual><anterior>ninguno</anterior></campo></tabla></registrar_muestra_clínica_paciente>
44	2011-12-14 20:27:37.567	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
45	2011-12-14 20:28:18.588	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
46	2011-12-14 20:30:20.093	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
47	2011-12-14 20:30:25.196	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
48	2011-12-14 20:41:45.433	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
49	2011-12-14 21:14:31.169	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
50	2011-12-14 21:19:24.826	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
51	2011-12-14 21:19:37.045	17	16	<?xml version="1.0" standalone="yes"?><Información_adicional>\n\t\t\t <tabla nombre="centro_salud_pacientes"><campo nombre="Centros de Salud"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I </anterior></campo></tabla><tabla nombre="tipos_consultas_pacientes"><campo nombre="Tipos de Consultas"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria </anterior></campo></tabla><tabla nombre="contactos_animales"><campo nombre="Animales"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro </anterior></campo></tabla><tabla nombre="tratamientos_pacientes"><campo nombre="Tratamientos"><actual>Ambulatorio Rural ,Ambulatorio Urbano ,Barrio Adentro I ,Clínica Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Otros ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </actual><anterior>Ambulatorio Urbano ,Ambulatorio Rural ,Clínica ,Barrio Adentro I Consulta ,Consulta Interna ,Dermatologia ,Geriatria Animales de Corral ,Aves ,Gato ,Perro Citotóxicos ,Glucorticoides ,Hormonas Sexuales ,Inmunosupresores ,Otros ,Radioterapia ,Sistémicos ,Tópicos </anterior></campo></tabla><tabla nombre="tiempo_evoluciones"><campo nombre="Evolución"><actual>24</actual><anterior>24</anterior></campo></tabla></Información_adicional>
\.


--
-- TOC entry 2314 (class 0 OID 30840)
-- Dependencies: 1677
-- Data for Name: categorias__cuerpos_micosis; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY categorias__cuerpos_micosis (id_cat_cue_mic, id_cat_cue, id_tip_mic) FROM stdin;
1	1	1
2	2	1
13	3	1
14	4	2
17	5	3
\.


--
-- TOC entry 2315 (class 0 OID 30845)
-- Dependencies: 1679
-- Data for Name: categorias_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY categorias_cuerpos (id_cat_cue, nom_cat_cue) FROM stdin;
1	Uña
2	Cuerpo
3	Piel
4	Piel
5	Cuerpo
\.


--
-- TOC entry 2316 (class 0 OID 30848)
-- Dependencies: 1680
-- Data for Name: categorias_cuerpos__lesiones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY categorias_cuerpos__lesiones (id_cat_cue_les, id_les, id_cat_cue) FROM stdin;
2	1	1
3	2	1
4	3	1
5	4	1
6	5	1
7	6	1
8	7	1
9	8	1
10	9	3
11	10	3
12	11	3
13	12	3
14	13	3
15	14	3
16	15	3
17	19	3
18	16	3
19	17	3
20	18	3
21	20	3
66	22	4
22	21	1
67	23	4
68	24	4
69	25	4
70	26	4
71	27	4
72	28	4
73	29	4
74	30	4
75	31	4
76	32	4
77	33	4
78	34	4
79	35	4
80	36	4
81	37	4
82	38	4
83	39	4
84	40	4
85	41	4
23	21	3
86	42	4
87	43	4
88	44	4
89	45	4
90	46	4
91	47	4
92	48	4
93	49	4
94	50	4
95	51	4
96	52	4
97	53	4
98	54	4
99	55	5
100	56	5
101	57	5
102	58	5
103	59	5
104	60	5
105	61	5
106	62	5
107	63	5
108	64	5
109	65	5
110	66	5
111	67	5
112	68	5
113	69	5
114	70	5
115	71	5
\.


--
-- TOC entry 2317 (class 0 OID 30853)
-- Dependencies: 1682
-- Data for Name: centro_salud_doctores; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY centro_salud_doctores (id_cen_sal_doc, id_cen_sal, id_doc, otr_cen_sal) FROM stdin;
5	5	33	\N
6	6	6	\N
9	5	34	\N
11	7	32	\N
\.


--
-- TOC entry 2319 (class 0 OID 30863)
-- Dependencies: 1686
-- Data for Name: centro_salud_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY centro_salud_pacientes (id_cen_sal_pac, id_his, id_cen_sal, otr_cen_sal) FROM stdin;
122	17	5	\N
123	17	4	\N
124	17	9	\N
92	3	5	\N
93	3	4	\N
94	3	9	\N
194	16	5	\N
195	16	4	\N
196	16	9	\N
197	16	7	\N
198	16	12	otro centro de salud
\.


--
-- TOC entry 2318 (class 0 OID 30858)
-- Dependencies: 1684
-- Data for Name: centro_saluds; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY centro_saluds (id_cen_sal, nom_cen_sal, des_cen_sal) FROM stdin;
1	Hospital General	Hospital General
2	Hospital Universitario	Hospital Universitario
3	Hospital Especializado	Hospital Especializado
4	Ambulatorio Urbano	Ambulatorio Urbano
5	Ambulatorio Rural	Ambulatorio Rural
6	Instituto	Instituto
7	Clínica	Clínica
8	Dispensario	Dispensario
9	Barrio Adentro I	Barrio Adentro I
10	Barrio Adentro II	Barrio Adentro II
11	Barrio Adentro III	Barrio Adentro III
12	Otros	Otros
\.


--
-- TOC entry 2320 (class 0 OID 30868)
-- Dependencies: 1688
-- Data for Name: contactos_animales; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY contactos_animales (id_con_ani, id_his, id_ani, otr_ani) FROM stdin;
77	17	3	\N
169	16	4	\N
170	16	3	\N
171	16	2	\N
172	16	5	pikachu
173	16	1	\N
\.


--
-- TOC entry 2321 (class 0 OID 30873)
-- Dependencies: 1690
-- Data for Name: doctores; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY doctores (id_doc, nom_doc, ape_doc, ced_doc, pas_doc, tel_doc, cor_doc, log_doc, fec_reg_doc) FROM stdin;
27	SAIB	SAIB	\N	83422503bcfc01d303030e8a7cc80efc	3622824	\N	SAIB	2011-06-26 01:06:59.641-04:30
33	Mary	Lopez	8752299	9f4b04c2eac4a3cfa351aff1564f7995	54564545646	mlopez@gmail.com	mlopez	2011-06-26 01:06:59.641-04:30
28	Mireya	Gonzalez	17302859	3e46a122f1961a8ec71f2a369f6d16ee	04265168824	\N	mgonzalez	2011-06-26 01:06:59.641-04:30
6	Luis	Marin	17302857	3e46a122f1961a8ec71f2a369f6d16ee	3622222	ninja.aoshi@gmail.com	lmarin	2011-06-26 01:06:59.641-04:30
34	Luis	Marin	17302858	3e46a122f1961a8ec71f2a369f6d16ee	3622222	lrm.prigramador@gmail.com	lmarinn	2011-07-08 15:58:52.908-04:30
32	Lisseth	Lozada	17651233	3e46a122f1961a8ec71f2a369f6d16ee	04269150722	risusefu15@gmail.com	llozada	2011-06-26 01:06:59.641-04:30
\.


--
-- TOC entry 2322 (class 0 OID 30882)
-- Dependencies: 1692
-- Data for Name: enfermedades_micologicas; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY enfermedades_micologicas (id_enf_mic, nom_enf_mic, id_tip_mic) FROM stdin;
1	Dermatofitosis	1
2	Onicomicosis dermatofitica	1
3	Onicomicosis no dermatofitica	1
4	Petitiriasis vericolor	1
5	Piedra blanca	1
6	Tiña negra	1
7	Oculomicosis	1
8	Otomicosis	1
9	Tinea capitis	1
10	Tinea barbae	1
11	Tinea corporis	1
12	Tinea cruris	1
13	Tinea imbricata	1
14	Tinea manuum	1
15	Tinea pedis	1
16	Tinea unguium	1
17	Cromomicosis dermatofitica	1
19	Actinomicetoma	2
20	Eumicetoma	2
21	Esporotricosis	2
22	Cromoblastomicosis	2
23	Lobomicosis	2
24	Coccidioidomicosis	3
25	Histoplasmosis	3
26	Paracoccidioidomicosis	3
27	Otros	2
28	Otros	3
18	Otros	1
\.


--
-- TOC entry 2323 (class 0 OID 30887)
-- Dependencies: 1694
-- Data for Name: enfermedades_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY enfermedades_pacientes (id_enf_pac, id_enf_mic, otr_enf_mic, esp_enf_mic, id_tip_mic_pac) FROM stdin;
268	19	\N	\N	45
269	20	\N	\N	45
270	21	\N	\N	45
330	19	\N	\N	56
331	20	\N	\N	56
332	21	\N	\N	56
333	22	\N	\N	56
334	23	\N	\N	56
335	27	subcu mic	\N	56
364	1	\N	\N	60
365	4	\N	\N	60
366	5	\N	\N	60
367	7	\N	\N	60
368	18	super mic	\N	60
\.


--
-- TOC entry 2324 (class 0 OID 30892)
-- Dependencies: 1696
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY estados (id_est, des_est, id_pai) FROM stdin;
1	Distrito Capital	1
2	Anzoátegui	1
3	Apure	1
4	Aragua	1
5	Barinas	1
6	Bolívar	1
7	Carabobo	1
8	Cojedes	1
9	Delta Amacuro	1
10	Falcón	1
11	Guárico	1
12	Lara	1
13	Mérida	1
14	Miranda	1
15	Monagas	1
16	Nueva Esparta	1
18	Portuguesa	1
19	Sucre	1
20	Táchira	1
21	Trujillo	1
22	Vargas	1
23	Yaracuy	1
24	Zulia	1
25	Amazonas	1
\.


--
-- TOC entry 2325 (class 0 OID 30897)
-- Dependencies: 1698
-- Data for Name: forma_infecciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY forma_infecciones (id_for_inf, des_for_inf) FROM stdin;
2	Picada de insecto
4	Mordedura de roedores
5	Instrumento metálico
6	Caza animales
8	Otros
1	Traumática
3	Pinchazo de espinas
7	Accidente laboratorio
9	Inhalatoria
10	Traumática
11	Accidente loboratorio
12	Otros
\.


--
-- TOC entry 2326 (class 0 OID 30900)
-- Dependencies: 1699
-- Data for Name: forma_infecciones__pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY forma_infecciones__pacientes (id_for_pac, id_for_inf, otr_for_inf, id_tip_mic_pac) FROM stdin;
36	1	\N	45
37	2	\N	45
38	3	\N	45
39	4	\N	45
40	5	\N	45
52	2	\N	56
53	8	subcu for les	56
\.


--
-- TOC entry 2327 (class 0 OID 30905)
-- Dependencies: 1701
-- Data for Name: forma_infecciones__tipos_micosis; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY forma_infecciones__tipos_micosis (id_for_inf_tip_mic, id_tip_mic, id_for_inf) FROM stdin;
1	2	1
2	2	2
3	2	3
6	2	4
7	2	5
8	2	6
9	2	7
10	2	8
18	3	9
19	3	10
20	3	11
21	3	12
\.


--
-- TOC entry 2328 (class 0 OID 30912)
-- Dependencies: 1704
-- Data for Name: historiales_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY historiales_pacientes (id_his, id_pac, des_his, id_doc, des_adi_pac_his, fec_his) FROM stdin;
3	7	Nuevamente se inicia otra historia para hacer un seguimiento de rastros de una enfermedad de la piel	6	El paciente por visualizacion padece de una coloracion en la piel.	2011-07-01 10:24:00.188-04:30
15	13	demo	6		2011-07-13 14:01:14.823-04:30
16	7	Prueba del historial de los pacientes para que se puedan registrar las enfermedades que se muestran en la aplicacion, un paciente puede tener una serie de enfermedades por lo que es necesario la creacion de un modulo que permita gestionar,	6	Gestionar de forma permanente las enfermedades que el paciente puede padecer a lo largo del periodo de tiempo, si el paciente se cura encontes ese historial queda descartado, y se procede a abrir un nuevo historico para el paciente que permita dicho.	2011-07-24 09:39:20.062-04:30
17	14	Enfermedad prueba	6	Enfermedad prueba	2011-11-16 16:19:51.588-04:30
18	27	demostracion de historial	6	demostracion del historial	2011-11-16 16:27:53.176-04:30
19	12	prototypo	6	Prototypo	2011-11-16 16:29:11.01-04:30
\.


--
-- TOC entry 2329 (class 0 OID 30921)
-- Dependencies: 1706
-- Data for Name: lesiones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY lesiones (id_les, nom_les) FROM stdin;
2	Onicodistrofia total
6	Leuconiquia
8	Dermatofitoma
10	Descamativa
11	Pruriginosa
12	Bordes activos
13	Inflamatoria
14	Extensa
15	Multiples
16	Pustulas
17	Alopecia
18	Granuloma tricofitico
19	Foliculitis
20	Querion de celso
21	Otros
22	Cabeza
24	Espalda
54	Otros
3	Coloración blanco-amarillenta
5	Onicolisis subungueal proximal
7	Coloración pardo-naranja
4	Coloración negruzca
1	Onicolisis subungueal distal
9	Placas eritematoscamosa
23	Tórax anterior
25	Flanco derecho
26	Flanco izquierdo
27	Brazo derecho
28	Brazo izquierdo
29	Pierna derecha
30	Pierna izquierda
31	Pie derecho
32	Pie izquierdo
33	Lesión única
34	Lesión múltiple
35	Con fístula
36	Sin fístula
37	Secreción granos de la fístula
38	Aumento volumen
39	Sin aumento volumen
40	Afectación hueso
41	Cutánea verrugosa
42	Cutánea tumoral
43	Cutánea en placa
44	Nódulos eritematosos
45	Atrofia central
46	Bordes activos
47	Cutánea fija
48	Cutánea linfangítica
49	Cutánea múltiple
50	Cutánea queloidal
51	Cutánea infiltrante
52	Cutánea gomosa
53	Cutánea ulcerada
55	Cutánea
56	Pulmonar
57	Pulmonar leve
58	Pulmonar moderada
59	Pulmonar aguda
60	Pulmonar crónica benigna
61	Pulmonar prograsiva
62	Diseminada
63	Tegumentaria (mucocutánea)
64	Ganglionar
65	Visceral
66	Mixta
67	Meníngea
68	Hepatoesplenomegalia
69	Generalizada
70	Histoplasmoma
71	Otros
\.


--
-- TOC entry 2330 (class 0 OID 30928)
-- Dependencies: 1709
-- Data for Name: lesiones_partes_cuerpos__pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY lesiones_partes_cuerpos__pacientes (id_les_par_cue_pac, otr_les_par_cue, id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac) FROM stdin;
198	\N	2	1	44
199	\N	3	1	44
200	\N	4	1	44
201	\N	5	1	44
202	\N	6	1	44
203	\N	7	1	44
204	\N	2	4	44
205	\N	3	4	44
298	\N	3	1	60
299	uno	22	1	60
300	\N	2	1	60
301	\N	7	2	60
302	dos	22	2	60
303	\N	5	2	60
304	\N	13	3	60
305	tres	23	3	60
306	\N	10	3	60
307	\N	14	4	60
308	\N	21	4	60
309	cuatro	23	4	60
233	\N	66	5	56
234	ggg	98	5	56
235	\N	67	5	56
236	\N	70	5	56
237	\N	72	5	56
\.


--
-- TOC entry 2331 (class 0 OID 30933)
-- Dependencies: 1711
-- Data for Name: localizaciones_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY localizaciones_cuerpos (id_loc_cue, nom_loc_cue, id_par_cue) FROM stdin;
\.


--
-- TOC entry 2332 (class 0 OID 30938)
-- Dependencies: 1713
-- Data for Name: modulos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY modulos (id_mod, cod_mod, des_mod, id_tip_usu) FROM stdin;
1	C	Configuración	2
2	R	Reportes	2
\.


--
-- TOC entry 2333 (class 0 OID 30943)
-- Dependencies: 1715
-- Data for Name: muestras_clinicas; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY muestras_clinicas (id_mue_cli, nom_mue_cli) FROM stdin;
1	Pelo
2	Escama
3	Uñas
4	Exudado
5	Biopsia Piel
6	Biopsia Otros Órganos
7	Líquido Peritoneal
8	Líquido Sinovial
9	Líquido Cefalorraquídeo(LCR)
10	Líquido Pleural
11	Lavado Bronquial
12	Esputo Espontáneo
13	Esputo Inducido
14	Aspirado Traqueal
15	Cepillado Protegido
16	Punción Pulmonar
17	Punción Pleural
18	Médula Ósea
20	Exudado Vaginal
21	Orina
22	Heces
23	Cateterismo
24	Sondaje
25	Bolsa Colectora
26	Cavidad Oral
27	Exudado Nasal
28	Muestras Ópticas
29	Exudado Conjuntival
30	Raspado Corneal
31	Aspirado Ocular
32	Lentes de Contacto
33	Catéteres Intravasculares
34	Catéteres Diálisis Peritoneal
35	Prótesis
36	Otros
19	Sangre
\.


--
-- TOC entry 2334 (class 0 OID 30948)
-- Dependencies: 1717
-- Data for Name: muestras_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY muestras_pacientes (id_mue_pac, id_his, id_mue_cli, otr_mue_cli) FROM stdin;
71	19	1	\N
72	19	2	\N
73	19	3	\N
74	19	4	\N
75	19	5	\N
76	19	6	\N
77	19	10	\N
78	19	11	\N
95	16	1	\N
96	16	3	\N
97	16	4	\N
98	16	8	\N
99	16	9	\N
100	16	36	Otra Clinicass
\.


--
-- TOC entry 2335 (class 0 OID 30953)
-- Dependencies: 1719
-- Data for Name: municipios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY municipios (id_mun, des_mun, id_est) FROM stdin;
1	\tLibertador Caracas\t\t 	1
2	\tAlto Orinoco\t\t 	25
3	\tAtabapo\t\t 	25
4	\tAtures\t\t 	25
5	\tAutana\t\t 	25
6	\tManapiare\t\t 	25
7	\tMaroa\t\t 	25
8	\tRío Negro\t\t 	25
9	\tAnaco\t\t 	2
10	\tAragua\t\t 	2
11	\tBolívar\t\t 	2
12	\tBruzual\t\t 	2
13	\tCajigal\t\t 	2
14	\tCarvajal\t\t 	2
15	\tDiego Bautista Urbaneja\t\t 	2
16	\tFreites\t\t 	2
17	\tGuanipa\t\t 	2
18	\tGuanta\t\t 	2
19	\tIndependencia\t\t 	2
20	\tLibertad\t\t 	2
21	\tMcGregor\t\t 	2
22	\tMiranda\t\t 	2
23	\tMonagas\t\t 	2
24	\tPeñalver\t\t 	2
25	\tPíritu\t\t 	2
26	\tSan Juan de Capistrano\t\t 	2
27	\tSanta Ana\t\t 	2
28	\tSimón Rodriguez\t\t 	2
29	\tSotillo\t\t 	2
30	\tAchaguas\t\t 	3
31	\tBiruaca\t\t 	3
32	\tMuñoz\t\t 	3
33	\tPáez\t\t 	3
34	\tPedro Camejo\t\t 	3
35	\tRómulo Gallegos\t\t 	3
36	\tSan Fernando\t\t 	3
37	\tBolívar\t\t 	4
38	\tCamatagua\t\t 	4
39	\tFrancisco Linares Alcántara\t\t 	4
40	\tGirardot\t\t 	4
41	\tJosé Angel Lamas\t\t 	4
42	\tJosé Félix Ribas\t\t 	4
43	\tJosé Rafael Revenga\t\t 	4
44	\tLibertador\t\t 	4
45	\tMario Briceño Iragorry\t\t 	4
46	\tOcumare de la Costa de Oro\t\t 	4
47	\tSan Casimiro\t\t 	4
48	\tSan Sebastián\t\t 	4
49	\tSantiago Mariño\t\t 	4
50	\tSantos Michelena\t\t 	4
51	\tSucre\t\t 	4
52	\tTovar\t\t 	4
53	\tUrdaneta\t\t 	4
54	\tZamora\t\t 	4
55	\tAlberto Arvelo Torrealba\t\t 	5
56	\tAndrés Eloy Blanco\t\t 	5
57	\tAntonio José de Sucre\t\t 	5
58	\tArismendi\t\t 	5
59	\tBarinas\t\t 	5
60	\tBolívar\t\t 	5
61	\tCruz Paredes\t\t 	5
62	\tEzequiel Zamora\t\t 	5
63	\tObispos\t\t 	5
64	\tPedraza\t\t 	5
65	\tRojas\t\t 	5
66	\tSosa\t\t 	5
67	\tCaroní\t\t 	6
68	\tCedeño\t\t 	6
69	\tEl Callao\t\t 	6
70	\tGran Sabana\t\t 	6
71	\tHeres\t\t 	6
72	\tPiar\t\t 	6
73	\tRaúl Leoni\t\t 	6
74	\tRoscio\t\t 	6
75	\tSifontes\t\t 	6
76	\tSucre\t\t 	6
77	\tPadre Pedro Chien\t\t 	6
78	\tBejuma\t\t 	7
79	\tCarlos Arvelo\t\t 	7
80	\tDiego Ibarra\t\t 	7
81	\tGuacara\t\t 	7
82	\tJuan José Mora\t\t 	7
83	\tLibertador\t\t 	7
84	\tLos Guayos\t\t 	7
85	\tMiranda\t\t 	7
86	\tMontalbán\t\t 	7
87	\tNaguanagua\t\t 	7
88	\tPuerto Cabello\t\t 	7
89	\tSan Diego\t\t 	7
90	\tSan Joaquín\t\t 	7
91	\tValencia\t\t 	7
92	\tAnzoátegui\t\t 	8
93	\tFalcón\t\t 	8
94	\tGirardot\t\t 	8
95	\tLima Blanco\t\t 	8
96	\tPao de San Juan Bautista\t\t 	8
97	\tRicaurte\t\t 	8
98	\tRómulo Gallegos\t\t 	8
99	\tSan Carlos\t\t 	8
100	\tTinaco\t\t 	8
101	\tAntonio Díaz\t\t 	9
102	\tCasacoima\t\t 	9
103	\tPedernales\t\t 	9
104	\tTucupita\t\t 	9
105	\tAcosta\t\t 	10
106	\tBolívar\t\t 	10
107	\tBuchivacoa\t\t 	10
108	\tCacique Manaure\t\t 	10
109	\tCarirubana\t\t 	10
110	\tColina\t\t 	10
111	\tDabajuro\t\t 	10
112	\tDemocracia\t\t 	10
113	\tFalcón\t\t 	10
114	\tFederación\t\t 	10
115	\tJacura\t\t 	10
116	\tLos Taques\t\t 	10
117	\tMauroa\t\t 	10
118	\tMiranda\t\t 	10
119	\tMonseñor Iturriza\t\t 	10
120	\tPalmasola\t\t 	10
121	\tPetit\t\t 	10
122	\tPíritu\t\t 	10
123	\tSan Francisco\t\t 	10
124	\tSilva\t\t 	10
125	\tSucre\t\t 	10
126	\tTocópero\t\t 	10
127	\tUnión\t\t 	10
128	\tUrumaco\t\t 	10
129	\tZamora\t\t 	10
130	\tCamaguán\t\t 	11
131	\tChaguaramas\t\t 	11
132	\tEl Socorro\t\t 	11
133	\tSebastian Francisco de Miranda\t\t 	11
134	\tJosé Félix Ribas\t\t 	11
135	\tJosé Tadeo Monagas\t\t 	11
136	\tJuan Germán Roscio\t\t 	11
137	\tJulián Mellado\t\t 	11
138	\tLas Mercedes\t\t 	11
139	\tLeonardo Infante\t\t 	11
140	\tPedro Zaraza\t\t 	11
141	\tOrtiz\t\t 	11
142	\tSan Gerónimo de Guayabal\t\t 	11
143	\tSan José de Guaribe\t\t 	11
144	\tSanta María de Ipire\t\t 	11
145	\tAndrés Eloy Blanco\t\t 	12
146	\tCrespo\t\t 	12
147	\tIribarren\t\t 	12
148	\tJiménez\t\t 	12
149	\tMorán\t\t 	12
150	\tPalavecino\t\t 	12
151	\tSimón Planas\t\t 	12
152	\tTorres\t\t 	12
153	\tUrdaneta\t\t 	12
154	\tAlberto Adriani\t\t 	13
155	\tAndrés Bello\t\t 	13
156	\tAntonio Pinto Salinas\t\t 	13
157	\tAricagua\t\t 	13
158	\tArzobispo Chacón\t\t 	13
159	\tCampo Elías\t\t 	13
160	\tCaracciolo Parra Olmedo\t\t 	13
161	\tCardenal Quintero\t\t 	13
162	\tGuaraque\t\t 	13
163	\tJulio César Salas\t\t 	13
164	\tJusto Briceño\t\t 	13
165	\tLibertador\t\t 	13
166	\tMiranda\t\t 	13
167	\tObispo Ramos de Lora\t\t 	13
168	\tPadre Noguera\t\t 	13
169	\tPueblo Llano\t\t 	13
170	\tRangel\t\t 	13
171	\tRivas Dávila\t\t 	13
172	\tSantos Marquina\t\t 	13
173	\tSucre\t\t 	13
174	\tTovar\t\t 	13
175	\tTulio Febres Cordero\t\t 	13
176	\tZea\t\t 	14
177	\tAcevedo\t\t 	14
178	\tAndrés Bello\t\t 	14
179	\tBaruta\t\t 	14
180	\tBrión\t\t 	14
181	\tBuroz\t\t 	14
182	\tCarrizal\t\t 	14
183	\tChacao\t\t 	14
184	\tCristóbal Rojas\t\t 	14
185	\tEl Hatillo\t\t 	14
186	\tGuaicaipuro\t\t 	14
187	\tIndependencia\t\t 	14
188	\tLander\t\t 	14
189	\tLos Salias\t\t 	14
190	\tPáez\t\t 	14
191	\tPaz Castillo\t\t 	14
192	\tPedro Gual\t\t 	14
193	\tPlaza\t\t 	14
194	\tSimón Bolívar\t\t 	14
195	\tSucre\t\t 	14
196	\tUrdaneta\t\t 	14
197	\tZamora\t\t 	14
198	\tAcosta\t\t 	15
199	\tAguasay\t\t 	15
200	\tBolívar\t\t 	15
201	\tCaripe\t\t 	15
202	\tCedeño\t\t 	15
203	\tEzequiel Zamora\t\t 	15
204	\tLibertador\t\t 	15
205	\tMaturín\t\t 	15
206	\tPiar\t\t 	15
207	\tPunceres\t\t 	15
208	\tSanta Bárbara\t\t 	15
209	\tSotillo\t\t 	15
210	\tUracoa\t\t 	15
211	\tAntolín del Campo\t\t 	16
212	\tArismendi\t\t 	16
213	\tDíaz\t\t 	16
214	\tGarcía\t\t 	16
215	\tGómez\t\t 	16
216	\tManeiro\t\t 	16
217	\tMarcano\t\t 	16
218	\tMariño\t\t 	16
219	\tPenínsula de Macanao\t\t 	16
220	\tTubores\t\t 	16
221	\tVillalba\t\t 	16
222	\tAgua Blanca\t\t 	18
223	\tAraure\t\t 	18
224	\tEsteller\t\t 	18
225	\tGuanare\t\t 	18
226	\tGuanarito\t\t 	18
227	\tMonseñor José Vicente de Unda\t\t 	18
228	\tOspino\t\t 	18
229	\tPáez\t\t 	18
230	\tPapelón\t\t 	18
231	\tSan Genaro de Boconoíto\t\t 	18
232	\tSan Rafael de Onoto\t\t 	18
233	\tSanta Rosalía\t\t 	18
234	\tSucre\t\t 	18
235	\tTurén\t\t 	18
236	\tAndrés Eloy Blanco\t\t 	19
237	\tAndrés Mata\t\t 	19
238	\tArismendi\t\t 	19
239	\tBenítez\t\t 	19
240	\tBermúdez\t\t 	19
241	\tBolívar\t\t 	19
242	\tCajigal\t\t 	19
243	\tCruz Salmerón Acosta\t\t 	19
244	\tLibertador\t\t 	19
245	\tMariño\t\t 	19
246	\tMejía\t\t 	19
247	\tMontes\t\t 	19
248	\tRibero\t\t 	19
249	\tSucre\t\t 	19
250	\tValdez\t\t 	19
251	\tAndrés Bello\t\t 	20
252	\tAntonio Rómulo Costa\t\t 	20
253	\tAyacucho\t\t 	20
254	\tBolívar\t\t 	20
255	\tCárdenas\t\t 	20
256	\tCórdoba\t\t 	20
257	\tFernández Feo\t\t 	20
258	\tFrancisco de Miranda\t\t 	20
259	\tGarcía de Hevia\t\t 	20
260	\tGuásimos\t\t 	20
261	\tIndependencia\t\t 	20
262	\tJáuregui\t\t 	20
263	\tJosé María Vargas\t\t 	20
264	\tJunín\t\t 	20
265	\tLibertad\t\t 	20
266	\tLibertador\t\t 	20
267	\t17. Lobatera\t\t 	20
268	\tMichelena\t\t 	20
269	\tPanamericano\t\t 	20
270	\tPedro María Ureña\t\t 	20
271	\tRafael Urdaneta\t\t 	20
272	\tSamuel Darío Maldonado\t\t 	20
273	\tSan Cristóbal\t\t 	20
274	\tSeboruco\t\t 	20
275	\tSimón Rodríguez\t\t 	20
276	\tSucre\t\t 	20
277	\tTorbes\t\t 	20
278	\tUribante\t\t 	20
279	\tSan Judas Tadeo\t\t 	20
280	\tAndrés Bello\t\t 	21
281	\tBoconó\t\t 	21
282	\tBolívar\t\t 	21
283	\tCandelaria\t\t 	21
284	\tCarache\t\t 	21
285	\tEscuque\t\t 	21
286	\tJosé Felipe Márquez Cañizalez\t\t 	21
287	\tJuan Vicente Campos Elías\t\t 	21
288	\tLa Ceiba\t\t 	21
289	\tMiranda\t\t 	21
290	\tMonte Carmelo\t\t 	21
291	\tMotatán\t\t 	21
292	\tPampán\t\t 	21
293	\tPampanito\t\t 	21
294	\tRafael Rangel\t\t 	21
295	\tSan Rafael de Carvajal\t\t 	21
296	\tSucre\t\t 	21
297	\tTrujillo\t\t 	21
298	\tUrdaneta\t\t 	21
299	\tValera\t\t 	21
300	\tVargas\t\t 	22
301	\tArístides Bastidas\t\t 	23
302	\tBolívar\t\t 	23
303	\tBruzual\t\t 	23
304	\tCocorote\t\t 	23
305	\tIndependencia\t\t 	23
306	\tJosé Antonio Páez\t\t 	23
307	\tLa Trinidad\t\t 	23
308	\tManuel Monge\t\t 	23
309	\tNirgua\t\t 	23
310	\tPeña\t\t 	23
311	\tSan Felipe\t\t 	23
312	\tSucre\t\t 	23
313	\tUrachiche\t\t 	23
314	\tVeroes\t\t 	23
315	\tAlmirante Padilla\t\t 	24
316	\tBaralt\t\t 	24
317	\tCabimas\t\t 	24
318	\tCatatumbo\t\t 	24
319	\tColón\t\t 	24
320	\tFrancisco Javier Pulgar\t\t 	24
321	\tGuajira\t\t 	24
322	\tJesús Enrique Losada\t\t 	24
323	\tJesús María Semprún\t\t 	24
324	\tLa Cañada de Urdaneta\t\t 	24
325	\tLagunillas\t\t 	24
326	\tMachiques de Perijá\t\t 	24
327	\tMara\t\t 	24
328	\tMaracaibo\t\t 	24
329	\tMiranda\t\t 	24
330	\tRosario de Perijá\t\t 	24
331	\tSan Francisco\t\t 	24
332	\tSanta Rita\t\t 	24
333	\tSimón Bolívar\t\t 	24
334	\tSucre\t\t 	24
335	\tValmore Rodríguez\t\t 	24
\.


--
-- TOC entry 2336 (class 0 OID 30958)
-- Dependencies: 1721
-- Data for Name: pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY pacientes (id_pac, ape_pac, nom_pac, ced_pac, fec_nac_pac, nac_pac, tel_hab_pac, tel_cel_pac, ocu_pac, ciu_pac, id_pai, id_est, id_mun, id_par, num_pac, id_doc, fec_reg_pac, sex_pac) FROM stdin;
11	Hernandez	Jose	17123098	1976-08-21	1	02125682345	04141235687	1	Caracas	1	1	1	\N	4	27	2011-06-11 20:03:33.627-04:30	M
12	Contreras	Gisela 	13456094	1970-09-25	2	00000	00000	4	Los Teques	1	1	196	\N	5	27	2011-06-11 20:20:43.702-04:30	F
13	Beltran	Carlos	7098456	1961-05-02	1	0000	0000	4	Merida	1	1	1	\N	6	27	2011-06-11 20:35:37.372-04:30	M
14	Wester	Mary	8752299	1965-05-02	1	02129874523	042691587412	6	Guarenas	1	1	193	\N	7	27	2011-06-11 22:08:34.736-04:30	F
16	Paciente	Paciente	17302857	2011-07-09	1	3622824	17302857	1	Guarenas	1	1	69	\N	6	6	2011-07-08 18:14:22.448-04:30	M
27	asd	demo	1234	2011-07-27	1	3622222	173028555	1	Guarenas	1	1	1	\N	7	6	2011-07-27 21:12:19.655-04:30	M
7	Lozada	Adriana	17651233	2011-09-06	1	3622824	04265168824	2	Guarenas	1	23	304	\N	1	6	2011-06-11 20:03:33.627-04:30	F
\.


--
-- TOC entry 2337 (class 0 OID 30964)
-- Dependencies: 1723
-- Data for Name: paises; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY paises (id_pai, des_pai, cod_pai) FROM stdin;
1	Venezuela	VEN
\.


--
-- TOC entry 2338 (class 0 OID 30969)
-- Dependencies: 1725
-- Data for Name: parroquias; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY parroquias (id_par, des_par, id_mun) FROM stdin;
\.


--
-- TOC entry 2339 (class 0 OID 30974)
-- Dependencies: 1727
-- Data for Name: partes_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY partes_cuerpos (id_par_cue, nom_par_cue) FROM stdin;
1	Pie
2	Mano
5	Cabeza
6	Tórax anterior
7	Flanco derecho
8	Flanco Izquierdo
9	Brazo derecho
10	Brazo izquierdo
11	Pierna derecha
12	Pierna izquierda
13	Pie derecho
14	Pie izquierdo
15	Piel
16	Pelo
18	Órganos
19	Huesos
\.


--
-- TOC entry 2340 (class 0 OID 30977)
-- Dependencies: 1728
-- Data for Name: partes_cuerpos__categorias_cuerpos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY partes_cuerpos__categorias_cuerpos (id_par_cue_cat_cue, id_cat_cue, id_par_cue) FROM stdin;
1	1	1
2	1	2
3	3	15
4	3	16
5	4	15
6	5	18
\.


--
-- TOC entry 2341 (class 0 OID 30984)
-- Dependencies: 1731
-- Data for Name: tiempo_evoluciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tiempo_evoluciones (id_tie_evo, id_his, tie_evo) FROM stdin;
2	3	5
4	18	0
5	19	0
3	17	1600
1	16	24
\.


--
-- TOC entry 2342 (class 0 OID 30990)
-- Dependencies: 1733
-- Data for Name: tipos_consultas; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_consultas (id_tip_con, nom_tip_con) FROM stdin;
1	Consulta
2	Dermatologia
3	Pediatria
4	Neumologia
5	Consulta Interna
6	Geriatria
7	urologia
8	Infectologia
9	Otros
\.


--
-- TOC entry 2343 (class 0 OID 30995)
-- Dependencies: 1735
-- Data for Name: tipos_consultas_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_consultas_pacientes (id_tip_con_pac, id_tip_con, id_his, otr_tip_con) FROM stdin;
87	3	3	\N
88	7	3	\N
110	1	17	\N
111	5	17	\N
112	2	17	\N
182	1	16	\N
183	5	16	\N
184	2	16	\N
185	6	16	\N
186	9	16	otro tipo consulta
\.


--
-- TOC entry 2344 (class 0 OID 31000)
-- Dependencies: 1737
-- Data for Name: tipos_estudios_micologicos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_estudios_micologicos (id_tip_est_mic, id_tip_mic, nom_tip_est_mic, id_tip_exa) FROM stdin;
1	1	Hifas delgadas tabicadas	1
2	1	Hifas gruesas tabicadas	1
3	1	Blastoconidias	1
4	1	Pseudohifas	1
5	1	Artroconidias	1
6	1	Hifas cortas y agrupamiento de esporas	1
7	1	Esporas endotrix	1
8	1	Esporas ectoendotrix	1
9	1	Microsporum canis	2
10	1	Microsporum gypseum	2
14	1	Trichophyton tonsurans	2
15	1	Trichophyton verrucosum	2
16	1	Trichophyton violaceum	2
18	1	Trichosporon	2
19	1	Geotrichum spp	2
20	1	Candita albicans	2
21	1	Candida no Candida albicans	2
11	1	Microsporum nanum	2
12	1	Trichophyton rubrum	2
13	1	Trichophyton mentagrophytes	2
17	1	Epidermophyton floccosum	2
22	1	Malassezia furfur	2
23	1	Malassezia pachydermatis	2
24	1	Malassezia spp	2
25	2	Levaduras simples	1
26	2	Blastoconidias	1
27	2	Levaduras en cadena	1
28	2	Células fumagoides	1
29	2	Hifas dematiaceas	1
30	2	Cuerpos asteroides	1
31	2	Otros	1
32	2	Sporothix schenckii	2
33	2	Cladiophialophora carrionii	2
34	2	Fonseca pedrosoi	2
35	2	Phialophora verrucosa	2
36	2	Rhinocladiella aquaspersa	2
37	2	Acremionium spp	2
38	2	Acremionium falciforme	2
39	2	Madurella grisea	2
40	2	Pseudallescheria boydii	2
41	2	Fusarium oxisporum	2
42	2	Fusarium solami	2
44	2	Aspergillus flavus	2
45	2	Aspergillus nidulans	2
46	2	Aspergillus fumigatus	2
47	2	Aspergillus spp	2
48	2	Nocardia brasiliensis	2
49	2	Streptomyces somaliensis	2
50	2	Actinomadura madurae	2
51	2	Fusarium spp	2
52	2	Paracoccidioide loboi (Histopatología)	2
53	2	Otros	2
43	2	Fusarium spp	2
54	3	Levaduras simples	1
55	3	Levaduras múltiples	1
56	3	Esférulas pared doble	1
57	3	Levaduras intracelulares	1
58	3	Otros	1
59	3	Coccidioides posadasii	2
60	3	Histoplasma capsulatum	2
61	3	Paracoccidioides brasiliensis	2
62	3	Otros	2
\.


--
-- TOC entry 2345 (class 0 OID 31005)
-- Dependencies: 1739
-- Data for Name: tipos_examenes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_examenes (id_tip_exa, nom_tip_exa) FROM stdin;
1	Examen directo
2	Agente Aislado
\.


--
-- TOC entry 2346 (class 0 OID 31010)
-- Dependencies: 1741
-- Data for Name: tipos_micosis; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_micosis (id_tip_mic, nom_tip_mic) FROM stdin;
1	Superficiales
3	Profundas
2	Subcutaneas
\.


--
-- TOC entry 2347 (class 0 OID 31015)
-- Dependencies: 1743
-- Data for Name: tipos_micosis_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_micosis_pacientes (id_tip_mic_pac, id_tip_mic, id_his) FROM stdin;
44	1	17
45	2	19
56	2	16
60	1	16
\.


--
-- TOC entry 2348 (class 0 OID 31018)
-- Dependencies: 1744
-- Data for Name: tipos_micosis_pacientes__tipos_estudios_micologicos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_micosis_pacientes__tipos_estudios_micologicos (id_tip_mic_pac_tip_est_mic, id_tip_mic_pac, id_tip_est_mic) FROM stdin;
34	44	1
35	44	2
36	44	3
41	56	26
42	56	28
58	60	1
59	60	3
60	60	5
61	60	7
\.


--
-- TOC entry 2349 (class 0 OID 31025)
-- Dependencies: 1747
-- Data for Name: tipos_usuarios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_usuarios (id_tip_usu, cod_tip_usu, des_tip_usu) FROM stdin;
1	adm	Administrador
2	med	Médicos
\.


--
-- TOC entry 2350 (class 0 OID 31028)
-- Dependencies: 1748
-- Data for Name: tipos_usuarios__usuarios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tipos_usuarios__usuarios (id_tip_usu_usu, id_doc, id_usu_adm, id_tip_usu) FROM stdin;
17	6	\N	2
36	\N	17	1
41	\N	21	1
43	27	\N	2
44	28	\N	2
45	\N	22	1
49	32	\N	2
50	33	\N	2
51	34	\N	2
52	\N	23	1
\.


--
-- TOC entry 2351 (class 0 OID 31035)
-- Dependencies: 1751
-- Data for Name: transacciones; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY transacciones (id_tip_tra, cod_tip_tra, des_tip_tra, id_mod) FROM stdin;
1	RED	Registrar enfermedades dermatologicas	1
2	MED	Modificar enfermedades dermatologicas	1
3	EED	Eliminar enfermedades dermatologicas	1
4	REF	Reportes de las estadisticas por enfermedad	2
9	RP	Registrar Paciente	1
10	MP	Modificar Paciente	1
11	EP	Eliminar Paciente	1
12	RHP	Registrar Historial de paciente	1
13	MHP	Modificar Historial de paciente	1
14	EHP	Modificar Historial de paciente	1
15	MCP	Muestra Clínica del paciente	1
16	IAP	Información Adicional del Paciente	1
\.


--
-- TOC entry 2352 (class 0 OID 31040)
-- Dependencies: 1753
-- Data for Name: transacciones_usuarios; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY transacciones_usuarios (id_tip_tra, id_tip_usu_usu, id_tra_usu) FROM stdin;
1	50	86
2	50	87
3	50	88
1	17	93
2	17	94
3	17	95
4	17	96
1	51	105
2	51	106
3	51	107
4	51	108
1	43	48
2	43	49
3	43	50
4	43	51
1	49	113
2	49	114
3	49	115
4	49	116
1	44	64
2	44	65
3	44	66
4	44	67
\.


--
-- TOC entry 2353 (class 0 OID 31045)
-- Dependencies: 1755
-- Data for Name: tratamientos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tratamientos (id_tra, nom_tra) FROM stdin;
1	Uso Antimicóticos
2	Uso Antibióticos
3	Tópicos
4	Sistémicos
5	Hormonas Sexuales
6	Glucorticoides
7	Citotóxicos
8	Radioterapia
9	Inmunosupresores
10	Otros
\.


--
-- TOC entry 2354 (class 0 OID 31050)
-- Dependencies: 1757
-- Data for Name: tratamientos_pacientes; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY tratamientos_pacientes (id_tra_pac, id_his, id_tra, otr_tra) FROM stdin;
156	17	7	\N
157	17	6	\N
158	17	10	\N
159	17	8	\N
124	3	7	\N
125	3	6	\N
240	16	7	\N
241	16	6	\N
242	16	5	\N
243	16	9	\N
244	16	10	otro previos
245	16	8	\N
246	16	4	\N
247	16	3	\N
\.


--
-- TOC entry 2355 (class 0 OID 31055)
-- Dependencies: 1759
-- Data for Name: usuarios_administrativos; Type: TABLE DATA; Schema: public; Owner: desarrollo_g
--

COPY usuarios_administrativos (id_usu_adm, nom_usu_adm, ape_usu_adm, pas_usu_adm, log_usu_adm, tel_usu_adm, fec_reg_usu_adm, adm_usu) FROM stdin;
17	SAIB	SAIB	fcc8c0a57ab902388613f2782eae3dd6	SAIB	04162102903	2011-06-04 14:24:44.315	t
21	Luis	Marin	3e46a122f1961a8ec71f2a369f6d16ee	lmarin	04265168824	2011-06-10 20:02:12.07	t
23	lmarin	marin	3e46a122f1961a8ec71f2a369f6d16ee	lmarin2	36222222	2011-07-08 16:10:19.402	t
22	Lisseth	Lozada	3e46a122f1961a8ec71f2a369f6d16ee	llozada	04269150722	2011-06-24 15:22:46.934	t
\.


SET search_path = saib_model, pg_catalog;

--
-- TOC entry 2356 (class 0 OID 31070)
-- Dependencies: 1763
-- Data for Name: wwwsqldesigner; Type: TABLE DATA; Schema: saib_model; Owner: postgres
--

COPY wwwsqldesigner (keyword, xmldata, dt) FROM stdin;
saib	<?xml version="1.0" encoding="utf-8" ?>\n<!-- SQL XML created by WWW SQL Designer, http://code.google.com/p/wwwsqldesigner/ -->\n<!-- Active URL: http://saib.zapto.org/wwwsqldesigner-2.6/ -->\n<sql>\n<datatypes db="postgresql">\n\n\t<group label="Numeric" color="rgb(238,238,170)">\n\n\t\t<type label="Integer" length="0" sql="INTEGER" re="INT" quote=""/>\n\n\t\t<type label="Small Integer" length="0" sql="SMALLINT" quote=""/>\n\n\t\t<type label="Big Integer" length="0" sql="BIGINT" quote=""/>\n\n\t\t<type label="Decimal" length="1" sql="DECIMAL" re="numeric" quote=""/>\n\n\t\t<type label="Serial" length="0" sql="SERIAL" re="SERIAL4" fk="Integer" quote=""/>\n\n\t\t<type label="Big Serial" length="0" sql="BIGSERIAL" re="SERIAL8" fk="Big Integer" quote=""/>\n\n\t\t<type label="Real" length="0" sql="BIGINT" quote=""/>\n\n\t\t<type label="Single precision" length="0" sql="FLOAT" quote=""/>\n\n\t\t<type label="Double precision" length="0" sql="DOUBLE" re="DOUBLE" quote=""/>\n\n\t</group>\n\n\n\n\t<group label="Character" color="rgb(255,200,200)">\n\n\t\t<type label="Char" length="1" sql="CHAR" quote="'"/>\n\n\t\t<type label="Varchar" length="1" sql="VARCHAR" re="CHARACTER VARYING" quote="'"/>\n\n\t\t<type label="Text" length="0" sql="TEXT" quote="'"/>\n\n\t\t<type label="Binary" length="1" sql="BYTEA" quote="'"/>\n\n\t\t<type label="Boolean" length="0" sql="BOOLEAN" quote="'"/>\n\n\t</group>\n\n\n\n\t<group label="Date &amp; Time" color="rgb(200,255,200)">\n\n\t\t<type label="Date" length="0" sql="DATE" quote="'"/>\n\n\t\t<type label="Time" length="1" sql="TIME" quote="'"/>\n\n\t\t<type label="Time w/ TZ" length="0" sql="TIME WITH TIME ZONE" quote="'"/>\n\n\t\t<type label="Interval" length="1" sql="INTERVAL" quote="'"/>\n\n\t\t<type label="Timestamp" length="1" sql="TIMESTAMP" quote="'"/>\n\n\t\t<type label="Timestamp w/ TZ" length="0" sql="TIMESTAMP WITH TIME ZONE" quote="'"/>\n\n\t\t<type label="Timestamp wo/ TZ" length="0" sql="TIMESTAMP WITHOUT TIME ZONE" quote="'"/>\n\n\t</group>\n\n\n\n\t<group label="Miscellaneous" color="rgb(200,200,255)">\n\n\t\t<type label="XML" length="1" sql="XML" quote="'"/>\n\n\t\t<type label="Bit" length="1" sql="BIT" quote="'"/>\n\n\t\t<type label="Bit Varying" length="1" sql="VARBIT" re="BIT VARYING" quote="'"/>\n\n\t\t<type label="Inet Host Addr" length="0" sql="INET" quote="'"/>\n\n\t\t<type label="Inet CIDR Addr" length="0" sql="CIDR" quote="'"/>\n\n\t\t<type label="Geometry" length="0" sql="GEOMETRY" quote="'"/>\n\n\t</group>\n\n</datatypes><table x="1233" y="495" name="historiales_pacientes">\n<row name="id_his" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('historiales_pacientes_id_his_seq'::regclass)</default></row>\n<row name="id_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="pacientes" row="id_pac" />\n</row>\n<row name="des_his" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_doc" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="doctores" row="id_doc" />\n</row>\n<row name="des_adi_pac_his" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>\n\tDiscripción adicional de si el paciente padece o no una enfermedad u otra cosa adicional.\n</comment>\n</row>\n<row name="fec_his" null="1" autoincrement="0">\n<datatype>TIMESTAMP WITH TIME ZONE</datatype>\n<default>'now()'</default></row>\n<key type="CHECK" name="17105_17204_1_not_null">\n</key>\n<key type="CHECK" name="17105_17204_2_not_null">\n</key>\n<key type="PRIMARY" name="historiales_pacientes_pkey">\n<part>id_his</part>\n</key>\n</table>\n<table x="488" y="228" name="pacientes">\n<row name="id_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('pacientes_id_pac_seq'::regclass)</default><comment>Id paciente</comment>\n</row>\n<row name="ape_pac" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<comment>Apellido del paciente</comment>\n</row>\n<row name="nom_pac" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Nombre del paciente</comment>\n</row>\n<row name="ced_pac" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Cedula del paciente</comment>\n</row>\n<row name="fec_nac_pac" null="0" autoincrement="0">\n<datatype>DATE</datatype>\n<comment>Fecha de nacimiento del paciente</comment>\n</row>\n<row name="nac_pac" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<comment>Nacionalidad del paciente</comment>\n</row>\n<row name="tel_hab_pac" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="tel_cel_pac" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="ocu_pac" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Ocupacion del paciente</comment>\n</row>\n<row name="ciu_pac" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Ciudad del paciente</comment>\n</row>\n<row name="id_pai" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="paises" row="id_pai" />\n</row>\n<row name="id_est" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="estados" row="id_est" />\n</row>\n<row name="id_mun" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="municipios" row="id_mun" />\n</row>\n<row name="id_par" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="parroquias" row="id_par" />\n</row>\n<row name="num_pac" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default></row>\n<row name="id_doc" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="doctores" row="id_doc" />\n</row>\n<row name="fec_reg_pac" null="1" autoincrement="0">\n<datatype>TIMESTAMP WITH TIME ZONE</datatype>\n<default>'now()'</default><comment>Fecha de registro del paciente</comment>\n</row>\n<row name="sex_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n</row>\n<key type="CHECK" name="17105_17244_1_not_null">\n</key>\n<key type="CHECK" name="17105_17244_2_not_null">\n</key>\n<key type="CHECK" name="17105_17244_23_not_null">\n</key>\n<key type="CHECK" name="17105_17244_5_not_null">\n</key>\n<key type="CHECK" name="17105_17244_6_not_null">\n</key>\n<key type="PRIMARY" name="pacientes_pkey">\n<part>id_pac</part>\n</key>\n</table>\n<table x="2054" y="781" name="tipos_micosis_pacientes">\n<row name="id_tip_mic_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_micosis_pacientes_id_tip_mic_pac_seq'::regclass)</default></row>\n<row name="id_tip_mic" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_micosis" row="id_tip_mic" />\n</row>\n<row name="id_his" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="historiales_pacientes" row="id_his" />\n</row>\n<key type="CHECK" name="17105_19170_1_not_null">\n</key>\n<key type="PRIMARY" name="tipos_micosis_pacientes_pkey">\n<part>id_tip_mic_pac</part>\n</key>\n<key type="UNIQUE" name="tipos_micosis_pacientes_unique">\n<part>id_his</part>\n<part>id_tip_mic</part>\n</key>\n</table>\n<table x="2896" y="714" name="tipos_micosis">\n<row name="id_tip_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_micosis_id_tip_mic_seq'::regclass)</default></row>\n<row name="nom_tip_mic" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17277_1_not_null">\n</key>\n<key type="PRIMARY" name="tipos_micosis_pkey">\n<part>id_tip_mic</part>\n</key>\n</table>\n<table x="21" y="32" name="tipos_usuarios__usuarios">\n<row name="id_tip_usu_usu" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_usuarios__usuarios_id_tip_usu_usu_seq'::regclass)</default></row>\n<row name="id_doc" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="doctores" row="id_doc" />\n</row>\n<row name="id_usu_adm" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="usuarios_administrativos" row="id_usu_adm" />\n</row>\n<row name="id_tip_usu" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_usuarios" row="id_tip_usu" />\n</row>\n<key type="CHECK" name="17105_17285_1_not_null">\n</key>\n<key type="CHECK" name="17105_17285_4_not_null">\n</key>\n<key type="PRIMARY" name="tipos_usuarios__usuarios_pkey">\n<part>id_tip_usu_usu</part>\n</key>\n<key type="UNIQUE" name="unique_tipos_usuarios__usuarios">\n<part>id_tip_usu</part>\n<part>id_usu_adm</part>\n<part>id_doc</part>\n</key>\n</table>\n<table x="978" y="164" name="doctores">\n<row name="id_doc" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('doctores_id_doc_seq'::regclass)</default><comment>identificador único para los doctores</comment>\n</row>\n<row name="nom_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Nombre del doctor</comment>\n</row>\n<row name="ape_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Apellido del doctor</comment>\n</row>\n<row name="ced_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Cédula del doctor</comment>\n</row>\n<row name="pas_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Contraseña del doctor</comment>\n</row>\n<row name="tel_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Teléfono del doctor</comment>\n</row>\n<row name="cor_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Correo electronico del doctor</comment>\n</row>\n<row name="log_doc" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Login con el que se loguara el doctor</comment>\n</row>\n<row name="fec_reg_doc" null="1" autoincrement="0">\n<datatype>TIMESTAMP WITH TIME ZONE</datatype>\n<default>'now()'</default></row>\n<key type="CHECK" name="17105_17166_1_not_null">\n</key>\n<key type="PRIMARY" name="doctores_pkey">\n<part>id_doc</part>\n</key>\n<comment>Registro de todos los doctores que del aplicativo</comment>\n</table>\n<table x="158" y="773" name="municipios">\n<row name="id_mun" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('municipios_id_mun_seq'::regclass)</default></row>\n<row name="des_mun" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_est" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="estados" row="id_est" />\n</row>\n<key type="CHECK" name="17105_18428_1_not_null">\n</key>\n<key type="PRIMARY" name="municipios_pkey">\n<part>id_mun</part>\n</key>\n</table>\n<table x="86" y="651" name="estados">\n<row name="id_est" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('estados_id_est_seq'::regclass)</default></row>\n<row name="des_est" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_pai" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="paises" row="id_pai" />\n</row>\n<key type="CHECK" name="17105_18420_1_not_null">\n</key>\n<key type="PRIMARY" name="estados_pkey">\n<part>id_est</part>\n</key>\n</table>\n<table x="799" y="1142" name="partes_cuerpos__categorias_cuerpos">\n<row name="id_par_cue_cat_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('partes_cuerpos__categorias_cuerpos_id_par_cue_cat_cue_seq'::regclass)</default></row>\n<row name="id_cat_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="categorias_cuerpos" row="id_cat_cue" />\n</row>\n<row name="id_par_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="partes_cuerpos" row="id_par_cue" />\n</row>\n<key type="CHECK" name="17105_19125_1_not_null">\n</key>\n<key type="CHECK" name="17105_19125_2_not_null">\n</key>\n<key type="CHECK" name="17105_19125_3_not_null">\n</key>\n<key type="PRIMARY" name="partes_cuerpos__categorias_cuerpos_pkey">\n<part>id_par_cue_cat_cue</part>\n</key>\n<key type="UNIQUE" name="partes_cuerpos__categorias_cuerpos_unique">\n<part>id_par_cue</part>\n<part>id_cat_cue</part>\n</key>\n<comment>Permite seleccionar a que categoria pertenece la parte del cuerpo</comment>\n</table>\n<table x="1194" y="1013" name="categorias_cuerpos">\n<row name="id_cat_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('categorias_cuerpos_id_cat_cue_seq'::regclass)</default></row>\n<row name="nom_cat_cue" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17131_1_not_null">\n</key>\n<key type="PRIMARY" name="categorias_cuerpos_pkey">\n<part>id_cat_cue</part>\n</key>\n</table>\n<table x="1506" y="914" name="categorias_cuerpos__lesiones">\n<row name="id_cat_cue_les" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('lesiones__partes_cuerpos_id_les_par_cue_seq'::regclass)</default></row>\n<row name="id_les" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="lesiones" row="id_les" />\n</row>\n<row name="id_cat_cue" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="categorias_cuerpos" row="id_cat_cue" />\n</row>\n<key type="CHECK" name="17105_17209_1_not_null">\n</key>\n<key type="PRIMARY" name="lesiones__partes_cuerpos_pkey">\n<part>id_cat_cue_les</part>\n</key>\n</table>\n<table x="1473" y="1150" name="lesiones_partes_cuerpos__pacientes">\n<row name="id_les_par_cue_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('lesiones_partes_cuerpos__pacientes_id_les_par_cue_pac_seq'::regclass)</default><comment>Leciones parted del cuerpo paciente</comment>\n</row>\n<row name="otr_les_par_cue" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Otras leciones de la parte del cuerpo del paciente</comment>\n</row>\n<row name="id_cat_cue_les" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="categorias_cuerpos__lesiones" row="id_cat_cue_les" />\n</row>\n<row name="id_par_cue_cat_cue" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="partes_cuerpos__categorias_cuerpos" row="id_par_cue_cat_cue" />\n</row>\n<row name="id_tip_mic_pac" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_micosis_pacientes" row="id_tip_mic_pac" />\n</row>\n<key type="CHECK" name="17105_17214_1_not_null">\n</key>\n<key type="PRIMARY" name="lesiones_partes_cuerpos__pacientes_pkey">\n<part>id_les_par_cue_pac</part>\n</key>\n<key type="UNIQUE" name="lesiones_partes_cuerpos__pacientes_unique">\n<part>id_par_cue_cat_cue</part>\n<part>id_cat_cue_les</part>\n<part>id_tip_mic_pac</part>\n</key>\n</table>\n<table x="2753" y="963" name="tipos_estudios_micologicos">\n<row name="id_tip_est_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_estudios_micologicos_id_tip_est_mic_seq'::regclass)</default></row>\n<row name="id_tip_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_micosis" row="id_tip_mic" />\n</row>\n<row name="nom_tip_est_mic" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_tip_exa" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_examenes" row="id_tip_exa" />\n</row>\n<key type="CHECK" name="17105_17272_1_not_null">\n</key>\n<key type="CHECK" name="17105_17272_2_not_null">\n</key>\n<key type="PRIMARY" name="tipos_estudios_micologicos_pkey">\n<part>id_tip_est_mic</part>\n</key>\n</table>\n<table x="1134" y="2443" name="transacciones">\n<row name="id_tip_tra" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('transacciones_id_tip_tra_seq'::regclass)</default></row>\n<row name="cod_tip_tra" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<row name="des_tip_tra" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_mod" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="modulos" row="id_mod" />\n</row>\n<key type="CHECK" name="17105_17292_1_not_null">\n</key>\n<key type="CHECK" name="17105_17292_2_not_null">\n</key>\n<key type="UNIQUE" name="transacciones_cod_tip_tra__id_mod">\n<part>cod_tip_tra</part>\n<part>id_mod</part>\n</key>\n<key type="PRIMARY" name="transacciones_pkey">\n<part>id_tip_tra</part>\n</key>\n</table>\n<table x="2392" y="605" name="centro_salud_doctores">\n<row name="id_cen_sal_doc" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('centro_salud_doctores_id_cen_sal_doc_seq'::regclass)</default><comment>Identificación del Centro de Salud del doctor</comment>\n</row>\n<row name="id_cen_sal" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="centro_saluds" row="id_cen_sal" />\n<comment>Identificación del Centro de Salud</comment>\n</row>\n<row name="id_doc" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="doctores" row="id_doc" />\n<comment>Identificación del doctor</comment>\n</row>\n<row name="otr_cen_sal" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Otro Centro de Salud</comment>\n</row>\n<key type="CHECK" name="17105_18773_1_not_null">\n</key>\n<key type="CHECK" name="17105_18773_2_not_null">\n</key>\n<key type="CHECK" name="17105_18773_3_not_null">\n</key>\n<key type="PRIMARY" name="centro_salud_doctores_pkey">\n<part>id_cen_sal_doc</part>\n</key>\n<key type="UNIQUE" name="centro_salud_doctores_unique">\n<part>id_doc</part>\n<part>id_cen_sal</part>\n</key>\n</table>\n<table x="69" y="903" name="parroquias">\n<row name="id_par" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('parroquias_id_par_seq'::regclass)</default></row>\n<row name="des_par" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_mun" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="municipios" row="id_mun" />\n</row>\n<key type="CHECK" name="17105_18436_1_not_null">\n</key>\n<key type="PRIMARY" name="parroquias_pkey">\n<part>id_par</part>\n</key>\n</table>\n<table x="57" y="525" name="paises">\n<row name="id_pai" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('paises_id_pai_seq'::regclass)</default></row>\n<row name="des_pai" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="cod_pai" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_18412_1_not_null">\n</key>\n<key type="PRIMARY" name="paises_pkey">\n<part>id_pai</part>\n</key>\n</table>\n<table x="1770" y="1496" name="tipos_micosis_pacientes__tipos_estudios_micologicos">\n<row name="id_tip_mic_pac_tip_est_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_micosis_pacientes__tipos_e_id_tip_mic_pac_tip_est_mic_seq'::regclass)</default></row>\n<row name="id_tip_mic_pac" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_micosis_pacientes" row="id_tip_mic_pac" />\n</row>\n<row name="id_tip_est_mic" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_estudios_micologicos" row="id_tip_est_mic" />\n</row>\n<key type="CHECK" name="17105_19305_1_not_null">\n</key>\n<key type="PRIMARY" name="tipos_micosis_pacientes__tipos_estudios_micologicos_pkey">\n<part>id_tip_mic_pac_tip_est_mic</part>\n</key>\n</table>\n<table x="1623" y="2740" name="auditoria_transacciones">\n<row name="id_aud_tra" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('auditoria_transacciones_id_aud_tra_seq'::regclass)</default></row>\n<row name="fec_aud_tra" null="1" autoincrement="0">\n<datatype>TIMESTAMP WITHOUT TIME ZONE</datatype>\n<default>NULL</default></row>\n<row name="id_tip_usu_usu" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_usuarios__usuarios" row="id_tip_usu_usu" />\n</row>\n<row name="id_tip_tra" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="transacciones" row="id_tip_tra" />\n</row>\n<row name="data_xml" null="1" autoincrement="0">\n<datatype>XML</datatype>\n<default>NULL</default><comment>Se guarda las modificaciones de la tabla y atributos realizada por los usuarios, todo en forma de XML</comment>\n</row>\n<key type="CHECK" name="17105_17121_1_not_null">\n</key>\n<key type="CHECK" name="17105_17121_3_not_null">\n</key>\n<key type="CHECK" name="17105_17121_4_not_null">\n</key>\n<key type="PRIMARY" name="auditoria_transacciones_pkey">\n<part>id_aud_tra</part>\n</key>\n<comment>Se guarda todos los eventos generados por los usuarios</comment>\n</table>\n<table x="1453" y="1468" name="antecedentes_pacientes">\n<row name="id_ant_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('antecedentes_pacientes_id_ant_pac_seq'::regclass)</default></row>\n<row name="id_ant_per" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="antecedentes_personales" row="id_ant_per" />\n</row>\n<row name="id_pac" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="pacientes" row="id_pac" />\n</row>\n<key type="CHECK" name="17105_17111_1_not_null">\n</key>\n<key type="CHECK" name="17105_17111_2_not_null">\n</key>\n<key type="PRIMARY" name="antecedentes_pacientes_pkey">\n<part>id_ant_pac</part>\n</key>\n</table>\n<table x="1949" y="1058" name="categorias__cuerpos_micosis">\n<row name="id_cat_cue_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('categorias__cuerpos_micosis_id_cat_cue_mic_seq'::regclass)</default></row>\n<row name="id_cat_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="categorias_cuerpos" row="id_cat_cue" />\n</row>\n<row name="id_tip_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_micosis" row="id_tip_mic" />\n</row>\n<key type="CHECK" name="17105_17126_1_not_null">\n</key>\n<key type="CHECK" name="17105_17126_2_not_null">\n</key>\n<key type="CHECK" name="17105_17126_3_not_null">\n</key>\n<key type="PRIMARY" name="categorias__cuerpos_micosis_pkey">\n<part>id_cat_cue_mic</part>\n</key>\n<key type="UNIQUE" name="categorias__cuerpos_micosis_unique">\n<part>id_tip_mic</part>\n<part>id_cat_cue</part>\n</key>\n</table>\n<table x="2364" y="1108" name="enfermedades_micologicas">\n<row name="id_enf_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('enfermedades_micologicas_id_enf_mic_seq'::regclass)</default></row>\n<row name="nom_enf_mic" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<row name="id_tip_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_micosis" row="id_tip_mic" />\n</row>\n<key type="CHECK" name="17105_17174_1_not_null">\n</key>\n<key type="CHECK" name="17105_17174_2_not_null">\n</key>\n<key type="CHECK" name="17105_17174_3_not_null">\n</key>\n<key type="PRIMARY" name="enfermedades_micologicas_pkey">\n<part>id_enf_mic</part>\n</key>\n</table>\n<table x="1838" y="1266" name="enfermedades_pacientes">\n<row name="id_enf_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('enfermedades_pacientes_id_enf_pac_seq'::regclass)</default></row>\n<row name="id_enf_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="enfermedades_micologicas" row="id_enf_mic" />\n</row>\n<row name="otr_enf_mic" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="esp_enf_mic" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_tip_mic_pac" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_micosis_pacientes" row="id_tip_mic_pac" />\n</row>\n<key type="CHECK" name="17105_17179_1_not_null">\n</key>\n<key type="CHECK" name="17105_17179_3_not_null">\n</key>\n<key type="PRIMARY" name="enfermedades_pacientes_pkey">\n<part>id_enf_pac</part>\n</key>\n</table>\n<table x="2045" y="256" name="centro_salud_pacientes">\n<row name="id_cen_sal_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('centro_salud_pacientes_id_cen_sal_pac_seq'::regclass)</default></row>\n<row name="id_his" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="historiales_pacientes" row="id_his" />\n</row>\n<row name="id_cen_sal" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="centro_saluds" row="id_cen_sal" />\n</row>\n<row name="otr_cen_sal" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17146_1_not_null">\n</key>\n<key type="CHECK" name="17105_17146_2_not_null">\n</key>\n<key type="CHECK" name="17105_17146_3_not_null">\n</key>\n<key type="PRIMARY" name="centro_salud_pacientes_pkey">\n<part>id_cen_sal_pac</part>\n</key>\n<key type="UNIQUE" name="centro_salud_pacientes_unique">\n<part>id_his</part>\n<part>id_cen_sal</part>\n</key>\n</table>\n<table x="2360" y="1458" name="contactos_animales">\n<row name="id_con_ani" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('contactos_animales_id_con_ani_seq'::regclass)</default></row>\n<row name="id_his" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="historiales_pacientes" row="id_his" />\n</row>\n<row name="id_ani" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="animales" row="id_ani" />\n</row>\n<row name="otr_ani" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17161_1_not_null">\n</key>\n<key type="CHECK" name="17105_17161_2_not_null">\n</key>\n<key type="CHECK" name="17105_17161_3_not_null">\n</key>\n<key type="PRIMARY" name="contactos_animales_pkey">\n<part>id_con_ani</part>\n</key>\n<key type="UNIQUE" name="contactos_animales_unique">\n<part>id_his</part>\n<part>id_ani</part>\n</key>\n</table>\n<table x="2768" y="419" name="centro_saluds">\n<row name="id_cen_sal" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('centro_salud_id_cen_sal_seq'::regclass)</default></row>\n<row name="nom_cen_sal" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<row name="des_cen_sal" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17141_1_not_null">\n</key>\n<key type="CHECK" name="17105_17141_2_not_null">\n</key>\n<key type="PRIMARY" name="centro_salud_pkey">\n<part>id_cen_sal</part>\n</key>\n</table>\n<table x="3829" y="721" name="forma_infecciones__tipos_micosis">\n<row name="id_for_inf_tip_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('forma_infecciones__tipos_micosis_id_for_inf_tip_mic_seq'::regclass)</default></row>\n<row name="id_tip_mic" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_micosis" row="id_tip_mic" />\n</row>\n<row name="id_for_inf" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="forma_infecciones" row="id_for_inf" />\n</row>\n<key type="CHECK" name="17105_17197_1_not_null">\n</key>\n<key type="CHECK" name="17105_17197_2_not_null">\n</key>\n<key type="CHECK" name="17105_17197_3_not_null">\n</key>\n<key type="PRIMARY" name="forma_infecciones__tipos_micosis_pkey">\n<part>id_for_inf_tip_mic</part>\n</key>\n<key type="UNIQUE" name="forma_infecciones__tipos_micosis_unique">\n<part>id_tip_mic</part>\n<part>id_for_inf</part>\n</key>\n</table>\n<table x="903" y="2316" name="modulos">\n<row name="id_mod" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('modulos_id_mod_seq'::regclass)</default></row>\n<row name="cod_mod" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="des_mod" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_tip_usu" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_usuarios" row="id_tip_usu" />\n</row>\n<key type="CHECK" name="17105_17229_1_not_null">\n</key>\n<key type="UNIQUE" name="modulos_cod_mod_unique">\n<part>cod_mod</part>\n<part>id_tip_usu</part>\n</key>\n<key type="PRIMARY" name="modulos_pkey">\n<part>id_mod</part>\n</key>\n</table>\n<table x="3153" y="845" name="forma_infecciones__pacientes">\n<row name="id_for_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('forma_infecciones__pacientes_id_for_pac_seq'::regclass)</default></row>\n<row name="id_for_inf" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="forma_infecciones" row="id_for_inf" />\n</row>\n<row name="otr_for_inf" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="id_tip_mic_pac" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_micosis_pacientes" row="id_tip_mic_pac" />\n</row>\n<key type="CHECK" name="17105_17192_1_not_null">\n</key>\n<key type="CHECK" name="17105_17192_2_not_null">\n</key>\n<key type="PRIMARY" name="forma_infecciones__pacientes_pkey">\n<part>id_for_pac</part>\n</key>\n<key type="UNIQUE" name="forma_infecciones__pacientes_unique">\n<part>id_tip_mic_pac</part>\n<part>id_for_inf</part>\n</key>\n</table>\n<table x="3550" y="798" name="forma_infecciones">\n<row name="id_for_inf" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('forma_infecciones_id_for_inf_seq'::regclass)</default></row>\n<row name="des_for_inf" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17189_1_not_null">\n</key>\n<key type="PRIMARY" name="forma_infecciones_pkey">\n<part>id_for_inf</part>\n</key>\n</table>\n<table x="1963" y="1797" name="muestras_pacientes">\n<row name="id_mue_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('muestras_pacientes_id_mue_pac_seq'::regclass)</default><comment>Id de la meustra del paciente</comment>\n</row>\n<row name="id_his" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="historiales_pacientes" row="id_his" />\n<comment>Id del historial</comment>\n</row>\n<row name="id_mue_cli" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="muestras_clinicas" row="id_mue_cli" />\n<comment>Id muestra cli</comment>\n</row>\n<row name="otr_mue_cli" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Otra meustra clinica</comment>\n</row>\n<key type="CHECK" name="17105_17239_1_not_null">\n</key>\n<key type="CHECK" name="17105_17239_2_not_null">\n</key>\n<key type="CHECK" name="17105_17239_3_not_null">\n</key>\n<key type="PRIMARY" name="muestras_pacientes_pkey">\n<part>id_mue_pac</part>\n</key>\n<key type="UNIQUE" name="muestras_pacientes_unique">\n<part>id_mue_cli</part>\n<part>id_his</part>\n</key>\n</table>\n<table x="1989" y="2519" name="transacciones_usuarios">\n<row name="id_tip_tra" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="transacciones" row="id_tip_tra" />\n</row>\n<row name="id_tip_usu_usu" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="tipos_usuarios__usuarios" row="id_tip_usu_usu" />\n</row>\n<row name="id_tra_usu" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('transacciones_usuarios_id_tra_usu_seq'::regclass)</default></row>\n<key type="CHECK" name="17105_17297_2_not_null">\n</key>\n<key type="CHECK" name="17105_17297_6_not_null">\n</key>\n<key type="PRIMARY" name="transacciones_usuarios_pkey">\n<part>id_tra_usu</part>\n</key>\n</table>\n<table x="157" y="1807" name="tipos_consultas_pacientes">\n<row name="id_tip_con_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_consultas_pacientes_id_tip_con_pac_seq'::regclass)</default><comment>Id tipos de consulta paciente</comment>\n</row>\n<row name="id_tip_con" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tipos_consultas" row="id_tip_con" />\n<comment>Id tipos de consulta</comment>\n</row>\n<row name="id_his" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="historiales_pacientes" row="id_his" />\n<comment>Id historico</comment>\n</row>\n<row name="otr_tip_con" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Otro tipo de consulta</comment>\n</row>\n<key type="CHECK" name="17105_17267_1_not_null">\n</key>\n<key type="CHECK" name="17105_17267_2_not_null">\n</key>\n<key type="CHECK" name="17105_17267_3_not_null">\n</key>\n<key type="PRIMARY" name="tipos_consultas_pacientes_pkey">\n<part>id_tip_con_pac</part>\n</key>\n<key type="UNIQUE" name="tipos_consultas_pacientes_unique">\n<part>id_tip_con</part>\n<part>id_his</part>\n</key>\n</table>\n<table x="510" y="1061" name="partes_cuerpos">\n<row name="id_par_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('partes_cuerpos_id_par_cue_seq'::regclass)</default></row>\n<row name="nom_par_cue" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17252_1_not_null">\n</key>\n<key type="PRIMARY" name="partes_cuerpos_pkey">\n<part>id_par_cue</part>\n</key>\n</table>\n<table x="624" y="1849" name="tratamientos_pacientes">\n<row name="id_tra_pac" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tratamientos_pacientes_id_tra_pac_seq'::regclass)</default><comment>Id transaccion paciente</comment>\n</row>\n<row name="id_his" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="historiales_pacientes" row="id_his" />\n<comment>Id historico</comment>\n</row>\n<row name="id_tra" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<relation table="tratamientos" row="id_tra" />\n<comment>Id tratamiento</comment>\n</row>\n<row name="otr_tra" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default><comment>Otro tratamiento</comment>\n</row>\n<key type="CHECK" name="17105_17307_1_not_null">\n</key>\n<key type="CHECK" name="17105_17307_2_not_null">\n</key>\n<key type="CHECK" name="17105_17307_3_not_null">\n</key>\n<key type="PRIMARY" name="tratamientos_pacientes_pkey">\n<part>id_tra_pac</part>\n</key>\n<key type="UNIQUE" name="tratamientos_pacientes_unique">\n<part>id_his</part>\n<part>id_tra</part>\n</key>\n</table>\n<table x="988" y="1803" name="tipos_usuarios">\n<row name="id_tip_usu" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_usuarios_id_tip_usu_seq'::regclass)</default></row>\n<row name="cod_tip_usu" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<row name="des_tip_usu" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17282_1_not_null">\n</key>\n<key type="CHECK" name="17105_17282_2_not_null">\n</key>\n<key type="PRIMARY" name="tipos_usuarios_pkey">\n<part>id_tip_usu</part>\n</key>\n<key type="UNIQUE" name="tipos_usuarios_unique">\n<part>cod_tip_usu</part>\n</key>\n</table>\n<table x="1101" y="869" name="lesiones">\n<row name="id_les" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('lesiones_id_les_seq'::regclass)</default></row>\n<row name="nom_les" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_19087_1_not_null">\n</key>\n<key type="PRIMARY" name="lesiones_id_les_pkey">\n<part>id_les</part>\n</key>\n</table>\n<table x="1232" y="730" name="tiempo_evoluciones">\n<row name="id_tie_evo" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tiempo_evoluciones_id_tie_evo_seq'::regclass)</default></row>\n<row name="id_his" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="historiales_pacientes" row="id_his" />\n</row>\n<row name="tie_evo" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>0</default></row>\n<key type="CHECK" name="17105_18883_1_not_null">\n</key>\n<key type="PRIMARY" name="tiempo_evoluciones_pkey">\n<part>id_tie_evo</part>\n</key>\n</table>\n<table x="3224" y="675" name="tipos_examenes">\n<row name="id_tip_exa" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_examenes_id_tip_exa_seq'::regclass)</default></row>\n<row name="nom_tip_exa" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_19279_1_not_null">\n</key>\n<key type="PRIMARY" name="tipos_examenes_pkey">\n<part>id_tip_exa</part>\n</key>\n</table>\n<table x="18" y="2282" name="antecedentes_personales">\n<row name="id_ant_per" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('antecedentes_personales_id_ant_per_seq'::regclass)</default></row>\n<row name="nom_ant_per" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17116_1_not_null">\n</key>\n<key type="PRIMARY" name="antecedentes_personales_pkey">\n<part>id_ant_per</part>\n</key>\n</table>\n<table x="2660" y="1246" name="animales">\n<row name="id_ani" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('animales_id_ani_seq'::regclass)</default></row>\n<row name="nom_ani" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17106_1_not_null">\n</key>\n<key type="PRIMARY" name="animales_pkey">\n<part>id_ani</part>\n</key>\n</table>\n<table x="471" y="1582" name="tipos_consultas">\n<row name="id_tip_con" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tipos_consultas_id_tip_con_seq'::regclass)</default><comment>id tipos consultas</comment>\n</row>\n<row name="nom_tip_con" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<key type="CHECK" name="17105_17262_1_not_null">\n</key>\n<key type="CHECK" name="17105_17262_2_not_null">\n</key>\n<key type="PRIMARY" name="tipos_consultas_pkey">\n<part>id_tip_con</part>\n</key>\n</table>\n<table x="1454" y="1931" name="muestras_clinicas">\n<row name="id_mue_cli" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('muestras_clinicas_id_mue_cli_seq'::regclass)</default><comment>Identificacion de la muestra clinica</comment>\n</row>\n<row name="nom_mue_cli" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<comment>Nombre muestra clinica</comment>\n</row>\n<key type="CHECK" name="17105_17234_1_not_null">\n</key>\n<key type="CHECK" name="17105_17234_2_not_null">\n</key>\n<key type="PRIMARY" name="muestras_clinicas_pkey">\n<part>id_mue_cli</part>\n</key>\n</table>\n<table x="726" y="1338" name="localizaciones_cuerpos">\n<row name="id_loc_cue" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('localizaciones_cuerpos_id_loc_cue_seq'::regclass)</default></row>\n<row name="nom_loc_cue" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<row name="id_par_cue" null="1" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>NULL</default><relation table="partes_cuerpos" row="id_par_cue" />\n</row>\n<key type="CHECK" name="17105_17219_1_not_null">\n</key>\n<key type="CHECK" name="17105_17219_2_not_null">\n</key>\n<key type="PRIMARY" name="localizaciones_cuerpos_pkey">\n<part>id_loc_cue</part>\n</key>\n</table>\n<table x="1460" y="82" name="usuarios_administrativos">\n<row name="id_usu_adm" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('usuarios_administrativos_id_usu_adm_seq'::regclass)</default></row>\n<row name="nom_usu_adm" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="ape_usu_adm" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="pas_usu_adm" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="log_usu_adm" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="tel_usu_adm" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<row name="fec_reg_usu_adm" null="1" autoincrement="0">\n<datatype>TIMESTAMP WITHOUT TIME ZONE</datatype>\n<default>'now()'</default><comment>Fecha de registro de los usuarios</comment>\n</row>\n<row name="adm_usu" null="1" autoincrement="0">\n<datatype>BOOLEAN</datatype>\n<default>NULL</default><comment>\n\tTRUE: si es un super usuario\n\tFALSE: si es usuario com limitaciones\n</comment>\n</row>\n<key type="CHECK" name="17105_17312_1_not_null">\n</key>\n<key type="UNIQUE" name="usuarios_administrativos_log_usu_adm_unique">\n<part>log_usu_adm</part>\n</key>\n<key type="PRIMARY" name="usuarios_administrativos_pkey">\n<part>id_usu_adm</part>\n</key>\n</table>\n<table x="1709" y="2106" name="tratamientos">\n<row name="id_tra" null="0" autoincrement="0">\n<datatype>INTEGER</datatype>\n<default>nextval('tratamientos_id_tra_seq'::regclass)</default></row>\n<row name="nom_tra" null="1" autoincrement="0">\n<datatype>VARCHAR</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="17105_17302_1_not_null">\n</key>\n<key type="PRIMARY" name="tratamientos_pkey">\n<part>id_tra</part>\n</key>\n</table>\n<table x="1771" y="2254" name="wwwsqldesigner">\n<row name="keyword" null="0" autoincrement="0">\n<datatype>VARCHAR</datatype>\n</row>\n<row name="xmldata" null="1" autoincrement="0">\n<datatype>TEXT</datatype>\n<default>NULL</default></row>\n<row name="dt" null="1" autoincrement="0">\n<datatype>TIMESTAMP WITHOUT TIME ZONE</datatype>\n<default>NULL</default></row>\n<key type="CHECK" name="27541_27542_1_not_null">\n</key>\n<key type="PRIMARY" name="wwwsqldesigner_pkey">\n<part>keyword</part>\n</key>\n</table>\n</sql>\n	\N
\.


SET search_path = public, pg_catalog;

--
-- TOC entry 2096 (class 2606 OID 31124)
-- Dependencies: 1669 1669
-- Name: animales_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY animales
    ADD CONSTRAINT animales_pkey PRIMARY KEY (id_ani);


--
-- TOC entry 2098 (class 2606 OID 31126)
-- Dependencies: 1671 1671
-- Name: antecedentes_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY antecedentes_pacientes
    ADD CONSTRAINT antecedentes_pacientes_pkey PRIMARY KEY (id_ant_pac);


--
-- TOC entry 2101 (class 2606 OID 31128)
-- Dependencies: 1673 1673
-- Name: antecedentes_personales_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY antecedentes_personales
    ADD CONSTRAINT antecedentes_personales_pkey PRIMARY KEY (id_ant_per);


SET default_tablespace = saib;

--
-- TOC entry 2103 (class 2606 OID 31130)
-- Dependencies: 1675 1675
-- Name: auditoria_transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

ALTER TABLE ONLY auditoria_transacciones
    ADD CONSTRAINT auditoria_transacciones_pkey PRIMARY KEY (id_aud_tra);


SET default_tablespace = '';

--
-- TOC entry 2106 (class 2606 OID 31132)
-- Dependencies: 1677 1677
-- Name: categorias__cuerpos_micosis_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_pkey PRIMARY KEY (id_cat_cue_mic);


--
-- TOC entry 2108 (class 2606 OID 31134)
-- Dependencies: 1677 1677 1677
-- Name: categorias__cuerpos_micosis_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_unique UNIQUE (id_cat_cue, id_tip_mic);


--
-- TOC entry 2113 (class 2606 OID 31576)
-- Dependencies: 1680 1680 1680
-- Name: categorias_cuerpos__lesiones_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT categorias_cuerpos__lesiones_unique UNIQUE (id_les, id_cat_cue);


--
-- TOC entry 2111 (class 2606 OID 31136)
-- Dependencies: 1679 1679
-- Name: categorias_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias_cuerpos
    ADD CONSTRAINT categorias_cuerpos_pkey PRIMARY KEY (id_cat_cue);


--
-- TOC entry 2119 (class 2606 OID 31138)
-- Dependencies: 1682 1682
-- Name: centro_salud_doctores_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_pkey PRIMARY KEY (id_cen_sal_doc);


--
-- TOC entry 2121 (class 2606 OID 31140)
-- Dependencies: 1682 1682 1682
-- Name: centro_salud_doctores_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_unique UNIQUE (id_doc, id_cen_sal);


--
-- TOC entry 2127 (class 2606 OID 31142)
-- Dependencies: 1686 1686
-- Name: centro_salud_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_pkey PRIMARY KEY (id_cen_sal_pac);


--
-- TOC entry 2129 (class 2606 OID 31144)
-- Dependencies: 1686 1686 1686
-- Name: centro_salud_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_unique UNIQUE (id_his, id_cen_sal);


--
-- TOC entry 2124 (class 2606 OID 31146)
-- Dependencies: 1684 1684
-- Name: centro_salud_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY centro_saluds
    ADD CONSTRAINT centro_salud_pkey PRIMARY KEY (id_cen_sal);


--
-- TOC entry 2132 (class 2606 OID 31148)
-- Dependencies: 1688 1688
-- Name: contactos_animales_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_pkey PRIMARY KEY (id_con_ani);


--
-- TOC entry 2134 (class 2606 OID 31150)
-- Dependencies: 1688 1688 1688
-- Name: contactos_animales_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_unique UNIQUE (id_his, id_ani);


--
-- TOC entry 2136 (class 2606 OID 31152)
-- Dependencies: 1690 1690
-- Name: doctores_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY doctores
    ADD CONSTRAINT doctores_pkey PRIMARY KEY (id_doc);


--
-- TOC entry 2139 (class 2606 OID 31154)
-- Dependencies: 1692 1692
-- Name: enfermedades_micologicas_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY enfermedades_micologicas
    ADD CONSTRAINT enfermedades_micologicas_pkey PRIMARY KEY (id_enf_mic);


--
-- TOC entry 2141 (class 2606 OID 31156)
-- Dependencies: 1694 1694
-- Name: enfermedades_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_pkey PRIMARY KEY (id_enf_pac);


--
-- TOC entry 2143 (class 2606 OID 31572)
-- Dependencies: 1694 1694 1694
-- Name: enfermedades_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_unique UNIQUE (id_enf_mic, id_tip_mic_pac);


--
-- TOC entry 2145 (class 2606 OID 31158)
-- Dependencies: 1696 1696
-- Name: estados_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (id_est);


--
-- TOC entry 2151 (class 2606 OID 31160)
-- Dependencies: 1699 1699
-- Name: forma_infecciones__pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_pkey PRIMARY KEY (id_for_pac);


--
-- TOC entry 2153 (class 2606 OID 31162)
-- Dependencies: 1699 1699 1699
-- Name: forma_infecciones__pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_unique UNIQUE (id_for_inf, id_tip_mic_pac);


--
-- TOC entry 2156 (class 2606 OID 31164)
-- Dependencies: 1701 1701
-- Name: forma_infecciones__tipos_micosis_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_pkey PRIMARY KEY (id_for_inf_tip_mic);


--
-- TOC entry 2158 (class 2606 OID 31166)
-- Dependencies: 1701 1701 1701
-- Name: forma_infecciones__tipos_micosis_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_unique UNIQUE (id_tip_mic, id_for_inf);


--
-- TOC entry 2148 (class 2606 OID 31168)
-- Dependencies: 1698 1698
-- Name: forma_infecciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY forma_infecciones
    ADD CONSTRAINT forma_infecciones_pkey PRIMARY KEY (id_for_inf);


--
-- TOC entry 2161 (class 2606 OID 31170)
-- Dependencies: 1704 1704
-- Name: historiales_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY historiales_pacientes
    ADD CONSTRAINT historiales_pacientes_pkey PRIMARY KEY (id_his);


--
-- TOC entry 2116 (class 2606 OID 31172)
-- Dependencies: 1680 1680
-- Name: lesiones__partes_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT lesiones__partes_cuerpos_pkey PRIMARY KEY (id_cat_cue_les);


--
-- TOC entry 2163 (class 2606 OID 31174)
-- Dependencies: 1706 1706
-- Name: lesiones_id_les_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY lesiones
    ADD CONSTRAINT lesiones_id_les_pkey PRIMARY KEY (id_les);


--
-- TOC entry 2166 (class 2606 OID 31176)
-- Dependencies: 1709 1709
-- Name: lesiones_partes_cuerpos__pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_pkey PRIMARY KEY (id_les_par_cue_pac);


--
-- TOC entry 2168 (class 2606 OID 31178)
-- Dependencies: 1709 1709 1709 1709
-- Name: lesiones_partes_cuerpos__pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_unique UNIQUE (id_cat_cue_les, id_par_cue_cat_cue, id_tip_mic_pac);


--
-- TOC entry 2171 (class 2606 OID 31180)
-- Dependencies: 1711 1711
-- Name: localizaciones_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY localizaciones_cuerpos
    ADD CONSTRAINT localizaciones_cuerpos_pkey PRIMARY KEY (id_loc_cue);


--
-- TOC entry 2173 (class 2606 OID 31182)
-- Dependencies: 1713 1713 1713
-- Name: modulos_cod_mod_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_cod_mod_unique UNIQUE (cod_mod, id_tip_usu);


--
-- TOC entry 2175 (class 2606 OID 31184)
-- Dependencies: 1713 1713
-- Name: modulos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_pkey PRIMARY KEY (id_mod);


--
-- TOC entry 2178 (class 2606 OID 31186)
-- Dependencies: 1715 1715
-- Name: muestras_clinicas_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY muestras_clinicas
    ADD CONSTRAINT muestras_clinicas_pkey PRIMARY KEY (id_mue_cli);


--
-- TOC entry 2180 (class 2606 OID 31188)
-- Dependencies: 1717 1717
-- Name: muestras_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_pkey PRIMARY KEY (id_mue_pac);


--
-- TOC entry 2182 (class 2606 OID 31190)
-- Dependencies: 1717 1717 1717
-- Name: muestras_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_unique UNIQUE (id_his, id_mue_cli);


--
-- TOC entry 2184 (class 2606 OID 31192)
-- Dependencies: 1719 1719
-- Name: municipios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY municipios
    ADD CONSTRAINT municipios_pkey PRIMARY KEY (id_mun);


--
-- TOC entry 2187 (class 2606 OID 31194)
-- Dependencies: 1721 1721
-- Name: pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_pkey PRIMARY KEY (id_pac);


--
-- TOC entry 2189 (class 2606 OID 31196)
-- Dependencies: 1723 1723
-- Name: paises_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (id_pai);


--
-- TOC entry 2191 (class 2606 OID 31198)
-- Dependencies: 1725 1725
-- Name: parroquias_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY parroquias
    ADD CONSTRAINT parroquias_pkey PRIMARY KEY (id_par);


--
-- TOC entry 2196 (class 2606 OID 31200)
-- Dependencies: 1728 1728
-- Name: partes_cuerpos__categorias_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_pkey PRIMARY KEY (id_par_cue_cat_cue);


--
-- TOC entry 2198 (class 2606 OID 31202)
-- Dependencies: 1728 1728 1728
-- Name: partes_cuerpos__categorias_cuerpos_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_unique UNIQUE (id_cat_cue, id_par_cue);


--
-- TOC entry 2194 (class 2606 OID 31204)
-- Dependencies: 1727 1727
-- Name: partes_cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY partes_cuerpos
    ADD CONSTRAINT partes_cuerpos_pkey PRIMARY KEY (id_par_cue);


--
-- TOC entry 2200 (class 2606 OID 31206)
-- Dependencies: 1731 1731
-- Name: tiempo_evoluciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tiempo_evoluciones
    ADD CONSTRAINT tiempo_evoluciones_pkey PRIMARY KEY (id_tie_evo);


--
-- TOC entry 2206 (class 2606 OID 31208)
-- Dependencies: 1735 1735
-- Name: tipos_consultas_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_pkey PRIMARY KEY (id_tip_con_pac);


--
-- TOC entry 2208 (class 2606 OID 31210)
-- Dependencies: 1735 1735 1735
-- Name: tipos_consultas_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_unique UNIQUE (id_tip_con, id_his);


--
-- TOC entry 2203 (class 2606 OID 31212)
-- Dependencies: 1733 1733
-- Name: tipos_consultas_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_consultas
    ADD CONSTRAINT tipos_consultas_pkey PRIMARY KEY (id_tip_con);


--
-- TOC entry 2211 (class 2606 OID 31214)
-- Dependencies: 1737 1737
-- Name: tipos_estudios_micologicos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_estudios_micologicos
    ADD CONSTRAINT tipos_estudios_micologicos_pkey PRIMARY KEY (id_tip_est_mic);


--
-- TOC entry 2213 (class 2606 OID 31216)
-- Dependencies: 1739 1739
-- Name: tipos_examenes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_examenes
    ADD CONSTRAINT tipos_examenes_pkey PRIMARY KEY (id_tip_exa);


--
-- TOC entry 2222 (class 2606 OID 31218)
-- Dependencies: 1744 1744
-- Name: tipos_micosis_pacientes__tipos_estudios_micologicos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_micologicos_pkey PRIMARY KEY (id_tip_mic_pac_tip_est_mic);


--
-- TOC entry 2224 (class 2606 OID 31574)
-- Dependencies: 1744 1744 1744
-- Name: tipos_micosis_pacientes__tipos_estudios_micologicos_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_micologicos_unique UNIQUE (id_tip_mic_pac, id_tip_est_mic);


--
-- TOC entry 2218 (class 2606 OID 31220)
-- Dependencies: 1743 1743
-- Name: tipos_micosis_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_pkey PRIMARY KEY (id_tip_mic_pac);


--
-- TOC entry 2220 (class 2606 OID 31222)
-- Dependencies: 1743 1743 1743
-- Name: tipos_micosis_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_unique UNIQUE (id_tip_mic, id_his);


--
-- TOC entry 2216 (class 2606 OID 31224)
-- Dependencies: 1741 1741
-- Name: tipos_micosis_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_micosis
    ADD CONSTRAINT tipos_micosis_pkey PRIMARY KEY (id_tip_mic);


--
-- TOC entry 2230 (class 2606 OID 31226)
-- Dependencies: 1748 1748
-- Name: tipos_usuarios__usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_pkey PRIMARY KEY (id_tip_usu_usu);


--
-- TOC entry 2226 (class 2606 OID 31228)
-- Dependencies: 1747 1747
-- Name: tipos_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_usuarios
    ADD CONSTRAINT tipos_usuarios_pkey PRIMARY KEY (id_tip_usu);


SET default_tablespace = saib;

--
-- TOC entry 2228 (class 2606 OID 31230)
-- Dependencies: 1747 1747
-- Name: tipos_usuarios_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

ALTER TABLE ONLY tipos_usuarios
    ADD CONSTRAINT tipos_usuarios_unique UNIQUE (cod_tip_usu);


SET default_tablespace = '';

--
-- TOC entry 2234 (class 2606 OID 31232)
-- Dependencies: 1751 1751 1751
-- Name: transacciones_cod_tip_tra__id_mod; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY transacciones
    ADD CONSTRAINT transacciones_cod_tip_tra__id_mod UNIQUE (id_mod, cod_tip_tra);


--
-- TOC entry 2236 (class 2606 OID 31234)
-- Dependencies: 1751 1751
-- Name: transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY transacciones
    ADD CONSTRAINT transacciones_pkey PRIMARY KEY (id_tip_tra);


--
-- TOC entry 2238 (class 2606 OID 31236)
-- Dependencies: 1753 1753
-- Name: transacciones_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY transacciones_usuarios
    ADD CONSTRAINT transacciones_usuarios_pkey PRIMARY KEY (id_tra_usu);


--
-- TOC entry 2244 (class 2606 OID 31238)
-- Dependencies: 1757 1757
-- Name: tratamientos_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_pkey PRIMARY KEY (id_tra_pac);


--
-- TOC entry 2246 (class 2606 OID 31240)
-- Dependencies: 1757 1757 1757
-- Name: tratamientos_pacientes_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_unique UNIQUE (id_his, id_tra);


--
-- TOC entry 2241 (class 2606 OID 31242)
-- Dependencies: 1755 1755
-- Name: tratamientos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tratamientos
    ADD CONSTRAINT tratamientos_pkey PRIMARY KEY (id_tra);


--
-- TOC entry 2232 (class 2606 OID 31244)
-- Dependencies: 1748 1748 1748 1748
-- Name: unique_tipos_usuarios__usuarios; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT unique_tipos_usuarios__usuarios UNIQUE (id_doc, id_usu_adm, id_tip_usu);


--
-- TOC entry 2248 (class 2606 OID 31246)
-- Dependencies: 1759 1759
-- Name: usuarios_administrativos_log_usu_adm_unique; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: 
--

ALTER TABLE ONLY usuarios_administrativos
    ADD CONSTRAINT usuarios_administrativos_log_usu_adm_unique UNIQUE (log_usu_adm);


SET default_tablespace = saib;

--
-- TOC entry 2250 (class 2606 OID 31248)
-- Dependencies: 1759 1759
-- Name: usuarios_administrativos_pkey; Type: CONSTRAINT; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

ALTER TABLE ONLY usuarios_administrativos
    ADD CONSTRAINT usuarios_administrativos_pkey PRIMARY KEY (id_usu_adm);


SET search_path = saib_model, pg_catalog;

SET default_tablespace = '';

--
-- TOC entry 2252 (class 2606 OID 31250)
-- Dependencies: 1763 1763
-- Name: wwwsqldesigner_pkey; Type: CONSTRAINT; Schema: saib_model; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wwwsqldesigner
    ADD CONSTRAINT wwwsqldesigner_pkey PRIMARY KEY (keyword);


SET search_path = public, pg_catalog;

SET default_tablespace = saib;

--
-- TOC entry 2094 (class 1259 OID 31251)
-- Dependencies: 1669
-- Name: animales_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX animales_index ON animales USING btree (id_ani);


--
-- TOC entry 2099 (class 1259 OID 31252)
-- Dependencies: 1673
-- Name: antecedentes_personales_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX antecedentes_personales_index ON antecedentes_personales USING btree (id_ant_per);


--
-- TOC entry 2104 (class 1259 OID 31253)
-- Dependencies: 1677
-- Name: categorias__cuerpos_micosis_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX categorias__cuerpos_micosis_index ON categorias__cuerpos_micosis USING btree (id_cat_cue_mic);


--
-- TOC entry 2109 (class 1259 OID 31254)
-- Dependencies: 1679
-- Name: categorias_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX categorias_cuerpos_index ON categorias_cuerpos USING btree (id_cat_cue);


SET default_tablespace = '';

--
-- TOC entry 2117 (class 1259 OID 31255)
-- Dependencies: 1682 1682 1682
-- Name: centro_salud_doctores_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: 
--

CREATE INDEX centro_salud_doctores_index ON centro_salud_doctores USING btree (id_cen_sal_doc, id_doc, id_cen_sal);


SET default_tablespace = saib;

--
-- TOC entry 2122 (class 1259 OID 31256)
-- Dependencies: 1684
-- Name: centro_salud_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX centro_salud_index ON centro_saluds USING btree (id_cen_sal);


--
-- TOC entry 2125 (class 1259 OID 31257)
-- Dependencies: 1686 1686 1686
-- Name: centro_salud_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX centro_salud_pacientes_index ON centro_salud_pacientes USING btree (id_cen_sal_pac, id_his, id_cen_sal);


--
-- TOC entry 2130 (class 1259 OID 31258)
-- Dependencies: 1688 1688 1688
-- Name: contactos_animales_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX contactos_animales_index ON contactos_animales USING btree (id_con_ani, id_his, id_ani);


--
-- TOC entry 2137 (class 1259 OID 31259)
-- Dependencies: 1692
-- Name: enfermedades_micologicas_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX enfermedades_micologicas_index ON enfermedades_micologicas USING btree (id_enf_mic);


--
-- TOC entry 2149 (class 1259 OID 31260)
-- Dependencies: 1699
-- Name: forma_infecciones__pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX forma_infecciones__pacientes_index ON forma_infecciones__pacientes USING btree (id_for_pac);


--
-- TOC entry 2154 (class 1259 OID 31261)
-- Dependencies: 1701
-- Name: forma_infecciones__tipos_micosis_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX forma_infecciones__tipos_micosis_index ON forma_infecciones__tipos_micosis USING btree (id_for_inf_tip_mic);


--
-- TOC entry 2146 (class 1259 OID 31262)
-- Dependencies: 1698
-- Name: forma_infecciones_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX forma_infecciones_index ON forma_infecciones USING btree (id_for_inf);


--
-- TOC entry 2159 (class 1259 OID 31263)
-- Dependencies: 1704
-- Name: historiales_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX historiales_pacientes_index ON historiales_pacientes USING btree (id_his);


--
-- TOC entry 2114 (class 1259 OID 31264)
-- Dependencies: 1680
-- Name: lesiones__partes_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX lesiones__partes_cuerpos_index ON categorias_cuerpos__lesiones USING btree (id_cat_cue_les);


--
-- TOC entry 2164 (class 1259 OID 31265)
-- Dependencies: 1709
-- Name: lesiones_partes_cuerpos__pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX lesiones_partes_cuerpos__pacientes_index ON lesiones_partes_cuerpos__pacientes USING btree (id_les_par_cue_pac);


--
-- TOC entry 2169 (class 1259 OID 31266)
-- Dependencies: 1711
-- Name: localizaciones_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX localizaciones_cuerpos_index ON localizaciones_cuerpos USING btree (id_loc_cue);


--
-- TOC entry 2176 (class 1259 OID 31267)
-- Dependencies: 1715
-- Name: muestras_clinicas_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX muestras_clinicas_index ON muestras_clinicas USING btree (id_mue_cli);


--
-- TOC entry 2185 (class 1259 OID 31268)
-- Dependencies: 1721
-- Name: pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX pacientes_index ON pacientes USING btree (id_pac);


--
-- TOC entry 2192 (class 1259 OID 31269)
-- Dependencies: 1727
-- Name: partes_cuerpos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX partes_cuerpos_index ON partes_cuerpos USING btree (id_par_cue);


--
-- TOC entry 2201 (class 1259 OID 31270)
-- Dependencies: 1733
-- Name: tipos_consultas_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_consultas_index ON tipos_consultas USING btree (id_tip_con);


--
-- TOC entry 2204 (class 1259 OID 31271)
-- Dependencies: 1735 1735 1735
-- Name: tipos_consultas_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_consultas_pacientes_index ON tipos_consultas_pacientes USING btree (id_tip_con_pac, id_tip_con, id_his);


--
-- TOC entry 2209 (class 1259 OID 31272)
-- Dependencies: 1737
-- Name: tipos_estudios_micologicos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_estudios_micologicos_index ON tipos_estudios_micologicos USING btree (id_tip_est_mic);


--
-- TOC entry 2214 (class 1259 OID 31273)
-- Dependencies: 1741
-- Name: tipos_micosis_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tipos_micosis_index ON tipos_micosis USING btree (id_tip_mic);


--
-- TOC entry 2239 (class 1259 OID 31274)
-- Dependencies: 1755
-- Name: tratamientos_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tratamientos_index ON tratamientos USING btree (id_tra);


--
-- TOC entry 2242 (class 1259 OID 31275)
-- Dependencies: 1757 1757 1757
-- Name: tratamientos_pacientes_index; Type: INDEX; Schema: public; Owner: desarrollo_g; Tablespace: saib
--

CREATE INDEX tratamientos_pacientes_index ON tratamientos_pacientes USING btree (id_tra_pac, id_his, id_tra);


--
-- TOC entry 2253 (class 2606 OID 31276)
-- Dependencies: 1673 1671 2100
-- Name: antecedentes_pacientes_id_ant_per_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY antecedentes_pacientes
    ADD CONSTRAINT antecedentes_pacientes_id_ant_per_fkey FOREIGN KEY (id_ant_per) REFERENCES antecedentes_personales(id_ant_per) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2254 (class 2606 OID 31281)
-- Dependencies: 1721 1671 2186
-- Name: antecedentes_pacientes_id_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY antecedentes_pacientes
    ADD CONSTRAINT antecedentes_pacientes_id_pac_fkey FOREIGN KEY (id_pac) REFERENCES pacientes(id_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2255 (class 2606 OID 31286)
-- Dependencies: 2235 1675 1751
-- Name: auditoria_transacciones_id_tip_tra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY auditoria_transacciones
    ADD CONSTRAINT auditoria_transacciones_id_tip_tra_fkey FOREIGN KEY (id_tip_tra) REFERENCES transacciones(id_tip_tra) ON UPDATE CASCADE;


--
-- TOC entry 2256 (class 2606 OID 31291)
-- Dependencies: 2229 1675 1748
-- Name: auditoria_transacciones_id_tip_usu_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY auditoria_transacciones
    ADD CONSTRAINT auditoria_transacciones_id_tip_usu_usu_fkey FOREIGN KEY (id_tip_usu_usu) REFERENCES tipos_usuarios__usuarios(id_tip_usu_usu) ON UPDATE CASCADE;


--
-- TOC entry 2259 (class 2606 OID 31296)
-- Dependencies: 2110 1679 1680
-- Name: categoria_cuerpos__partes_cuerpos_id_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT categoria_cuerpos__partes_cuerpos_id_cat_cue_fkey FOREIGN KEY (id_cat_cue) REFERENCES categorias_cuerpos(id_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2257 (class 2606 OID 31301)
-- Dependencies: 1677 1679 2110
-- Name: categorias__cuerpos_micosis_id_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_id_cat_cue_fkey FOREIGN KEY (id_cat_cue) REFERENCES categorias_cuerpos(id_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2258 (class 2606 OID 31306)
-- Dependencies: 2215 1741 1677
-- Name: categorias__cuerpos_micosis_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias__cuerpos_micosis
    ADD CONSTRAINT categorias__cuerpos_micosis_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2261 (class 2606 OID 31311)
-- Dependencies: 2123 1684 1682
-- Name: centro_salud_doctores_id_cen_sal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_id_cen_sal_fkey FOREIGN KEY (id_cen_sal) REFERENCES centro_saluds(id_cen_sal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2262 (class 2606 OID 31316)
-- Dependencies: 1682 2135 1690
-- Name: centro_salud_doctores_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_doctores
    ADD CONSTRAINT centro_salud_doctores_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2263 (class 2606 OID 31321)
-- Dependencies: 1686 2123 1684
-- Name: centro_salud_pacientes_id_cen_sal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_id_cen_sal_fkey FOREIGN KEY (id_cen_sal) REFERENCES centro_saluds(id_cen_sal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2264 (class 2606 OID 31326)
-- Dependencies: 1686 2160 1704
-- Name: centro_salud_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY centro_salud_pacientes
    ADD CONSTRAINT centro_salud_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2265 (class 2606 OID 31331)
-- Dependencies: 1688 2095 1669
-- Name: contactos_animales_id_ani_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_id_ani_fkey FOREIGN KEY (id_ani) REFERENCES animales(id_ani) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2266 (class 2606 OID 31336)
-- Dependencies: 1688 2160 1704
-- Name: contactos_animales_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY contactos_animales
    ADD CONSTRAINT contactos_animales_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2267 (class 2606 OID 31341)
-- Dependencies: 1692 2215 1741
-- Name: enfermedades_micologicas_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY enfermedades_micologicas
    ADD CONSTRAINT enfermedades_micologicas_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2268 (class 2606 OID 31346)
-- Dependencies: 2138 1692 1694
-- Name: enfermedades_pacientes_id_enf_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_id_enf_mic_fkey FOREIGN KEY (id_enf_mic) REFERENCES enfermedades_micologicas(id_enf_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2269 (class 2606 OID 31351)
-- Dependencies: 1694 2217 1743
-- Name: enfermedades_pacientes_id_tip_enf_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY enfermedades_pacientes
    ADD CONSTRAINT enfermedades_pacientes_id_tip_enf_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2270 (class 2606 OID 31356)
-- Dependencies: 1723 2188 1696
-- Name: estados_id_pai_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_id_pai_fkey FOREIGN KEY (id_pai) REFERENCES paises(id_pai) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2271 (class 2606 OID 31361)
-- Dependencies: 1698 2147 1699
-- Name: forma_infecciones__pacientes_id_for_inf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_id_for_inf_fkey FOREIGN KEY (id_for_inf) REFERENCES forma_infecciones(id_for_inf) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2272 (class 2606 OID 31366)
-- Dependencies: 1743 2217 1699
-- Name: forma_infecciones__pacientes_id_tip_mic_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__pacientes
    ADD CONSTRAINT forma_infecciones__pacientes_id_tip_mic_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2273 (class 2606 OID 31371)
-- Dependencies: 1701 2147 1698
-- Name: forma_infecciones__tipos_micosis_id_for_inf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_id_for_inf_fkey FOREIGN KEY (id_for_inf) REFERENCES forma_infecciones(id_for_inf) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2274 (class 2606 OID 31376)
-- Dependencies: 1741 2215 1701
-- Name: forma_infecciones__tipos_micosis_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY forma_infecciones__tipos_micosis
    ADD CONSTRAINT forma_infecciones__tipos_micosis_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2275 (class 2606 OID 31381)
-- Dependencies: 1704 2135 1690
-- Name: historiales_pacientes_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY historiales_pacientes
    ADD CONSTRAINT historiales_pacientes_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2276 (class 2606 OID 31386)
-- Dependencies: 1721 1704 2186
-- Name: historiales_pacientes_id_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY historiales_pacientes
    ADD CONSTRAINT historiales_pacientes_id_pac_fkey FOREIGN KEY (id_pac) REFERENCES pacientes(id_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2260 (class 2606 OID 31391)
-- Dependencies: 1680 1706 2162
-- Name: lesiones__partes_cuerpos_id_les_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY categorias_cuerpos__lesiones
    ADD CONSTRAINT lesiones__partes_cuerpos_id_les_fkey FOREIGN KEY (id_les) REFERENCES lesiones(id_les) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2277 (class 2606 OID 31396)
-- Dependencies: 1680 1709 2115
-- Name: lesiones_partes_cuerpos__pacientes_id_cat_cue_les_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_id_cat_cue_les_fkey FOREIGN KEY (id_cat_cue_les) REFERENCES categorias_cuerpos__lesiones(id_cat_cue_les) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2278 (class 2606 OID 31401)
-- Dependencies: 2195 1728 1709
-- Name: lesiones_partes_cuerpos__pacientes_id_par_cue_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_id_par_cue_cat_cue_fkey FOREIGN KEY (id_par_cue_cat_cue) REFERENCES partes_cuerpos__categorias_cuerpos(id_par_cue_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2279 (class 2606 OID 31406)
-- Dependencies: 1709 2217 1743
-- Name: lesiones_partes_cuerpos__pacientes_id_tip_mic_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY lesiones_partes_cuerpos__pacientes
    ADD CONSTRAINT lesiones_partes_cuerpos__pacientes_id_tip_mic_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2280 (class 2606 OID 31411)
-- Dependencies: 1727 1711 2193
-- Name: localizaciones_cuerpos_id_par_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY localizaciones_cuerpos
    ADD CONSTRAINT localizaciones_cuerpos_id_par_cue_fkey FOREIGN KEY (id_par_cue) REFERENCES partes_cuerpos(id_par_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2281 (class 2606 OID 31416)
-- Dependencies: 1747 2225 1713
-- Name: modulos_id_tip_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY modulos
    ADD CONSTRAINT modulos_id_tip_usu_fkey FOREIGN KEY (id_tip_usu) REFERENCES tipos_usuarios(id_tip_usu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2282 (class 2606 OID 31421)
-- Dependencies: 1717 2160 1704
-- Name: muestras_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2283 (class 2606 OID 31426)
-- Dependencies: 2177 1717 1715
-- Name: muestras_pacientes_id_mue_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY muestras_pacientes
    ADD CONSTRAINT muestras_pacientes_id_mue_cli_fkey FOREIGN KEY (id_mue_cli) REFERENCES muestras_clinicas(id_mue_cli) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2284 (class 2606 OID 31431)
-- Dependencies: 2144 1696 1719
-- Name: municipios_id_est_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY municipios
    ADD CONSTRAINT municipios_id_est_fkey FOREIGN KEY (id_est) REFERENCES estados(id_est) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2285 (class 2606 OID 31436)
-- Dependencies: 1721 1690 2135
-- Name: pacientes_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2286 (class 2606 OID 31441)
-- Dependencies: 1696 2144 1721
-- Name: pacientes_id_est_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_est_fkey FOREIGN KEY (id_est) REFERENCES estados(id_est) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2287 (class 2606 OID 31446)
-- Dependencies: 1719 1721 2183
-- Name: pacientes_id_mun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_mun_fkey FOREIGN KEY (id_mun) REFERENCES municipios(id_mun) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2288 (class 2606 OID 31451)
-- Dependencies: 2188 1723 1721
-- Name: pacientes_id_pai_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_pai_fkey FOREIGN KEY (id_pai) REFERENCES paises(id_pai) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2289 (class 2606 OID 31456)
-- Dependencies: 2190 1721 1725
-- Name: pacientes_id_par_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY pacientes
    ADD CONSTRAINT pacientes_id_par_fkey FOREIGN KEY (id_par) REFERENCES parroquias(id_par) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2290 (class 2606 OID 31461)
-- Dependencies: 2183 1725 1719
-- Name: parroquias_id_mun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY parroquias
    ADD CONSTRAINT parroquias_id_mun_fkey FOREIGN KEY (id_mun) REFERENCES municipios(id_mun) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2291 (class 2606 OID 31466)
-- Dependencies: 1679 1728 2110
-- Name: partes_cuerpos__categorias_cuerpos_id_cat_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_id_cat_cue_fkey FOREIGN KEY (id_cat_cue) REFERENCES categorias_cuerpos(id_cat_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2292 (class 2606 OID 31471)
-- Dependencies: 2193 1728 1727
-- Name: partes_cuerpos__categorias_cuerpos_id_par_cue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY partes_cuerpos__categorias_cuerpos
    ADD CONSTRAINT partes_cuerpos__categorias_cuerpos_id_par_cue_fkey FOREIGN KEY (id_par_cue) REFERENCES partes_cuerpos(id_par_cue) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2293 (class 2606 OID 31476)
-- Dependencies: 1704 1731 2160
-- Name: tiempo_evoluciones_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tiempo_evoluciones
    ADD CONSTRAINT tiempo_evoluciones_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2294 (class 2606 OID 31481)
-- Dependencies: 1704 2160 1735
-- Name: tipos_consultas_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2295 (class 2606 OID 31486)
-- Dependencies: 1733 1735 2202
-- Name: tipos_consultas_pacientes_id_tip_con_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_consultas_pacientes
    ADD CONSTRAINT tipos_consultas_pacientes_id_tip_con_fkey FOREIGN KEY (id_tip_con) REFERENCES tipos_consultas(id_tip_con) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2296 (class 2606 OID 31491)
-- Dependencies: 1739 2212 1737
-- Name: tipos_estudios_micologicos_id_tip_exa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_estudios_micologicos
    ADD CONSTRAINT tipos_estudios_micologicos_id_tip_exa_fkey FOREIGN KEY (id_tip_exa) REFERENCES tipos_examenes(id_tip_exa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2297 (class 2606 OID 31496)
-- Dependencies: 2215 1737 1741
-- Name: tipos_estudios_micologicos_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_estudios_micologicos
    ADD CONSTRAINT tipos_estudios_micologicos_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2300 (class 2606 OID 31501)
-- Dependencies: 1744 2210 1737
-- Name: tipos_micosis_pacientes__tipos_estudios_mic_id_tip_est_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_mic_id_tip_est_mic_fkey FOREIGN KEY (id_tip_est_mic) REFERENCES tipos_estudios_micologicos(id_tip_est_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2301 (class 2606 OID 31506)
-- Dependencies: 1744 2217 1743
-- Name: tipos_micosis_pacientes__tipos_estudios_mic_id_tip_mic_pac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes__tipos_estudios_micologicos
    ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_mic_id_tip_mic_pac_fkey FOREIGN KEY (id_tip_mic_pac) REFERENCES tipos_micosis_pacientes(id_tip_mic_pac) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2298 (class 2606 OID 31511)
-- Dependencies: 1743 2160 1704
-- Name: tipos_micosis_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2299 (class 2606 OID 31516)
-- Dependencies: 1743 2215 1741
-- Name: tipos_micosis_pacientes_id_tip_mic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_micosis_pacientes
    ADD CONSTRAINT tipos_micosis_pacientes_id_tip_mic_fkey FOREIGN KEY (id_tip_mic) REFERENCES tipos_micosis(id_tip_mic) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2302 (class 2606 OID 31521)
-- Dependencies: 1748 2135 1690
-- Name: tipos_usuarios__usuarios_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doctores(id_doc) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2303 (class 2606 OID 31526)
-- Dependencies: 2225 1747 1748
-- Name: tipos_usuarios__usuarios_id_tip_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_id_tip_usu_fkey FOREIGN KEY (id_tip_usu) REFERENCES tipos_usuarios(id_tip_usu) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2304 (class 2606 OID 31531)
-- Dependencies: 1759 2249 1748
-- Name: tipos_usuarios__usuarios_id_usu_adm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tipos_usuarios__usuarios
    ADD CONSTRAINT tipos_usuarios__usuarios_id_usu_adm_fkey FOREIGN KEY (id_usu_adm) REFERENCES usuarios_administrativos(id_usu_adm) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2305 (class 2606 OID 31536)
-- Dependencies: 1713 2174 1751
-- Name: transacciones_id_mod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY transacciones
    ADD CONSTRAINT transacciones_id_mod_fkey FOREIGN KEY (id_mod) REFERENCES modulos(id_mod) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2306 (class 2606 OID 31541)
-- Dependencies: 1751 2235 1753
-- Name: transacciones_usuarios_id_tip_tra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY transacciones_usuarios
    ADD CONSTRAINT transacciones_usuarios_id_tip_tra_fkey FOREIGN KEY (id_tip_tra) REFERENCES transacciones(id_tip_tra) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2307 (class 2606 OID 31546)
-- Dependencies: 1748 2229 1753
-- Name: transacciones_usuarios_id_tip_usu_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY transacciones_usuarios
    ADD CONSTRAINT transacciones_usuarios_id_tip_usu_usu_fkey FOREIGN KEY (id_tip_usu_usu) REFERENCES tipos_usuarios__usuarios(id_tip_usu_usu) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2308 (class 2606 OID 31551)
-- Dependencies: 1704 2160 1757
-- Name: tratamientos_pacientes_id_his_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_id_his_fkey FOREIGN KEY (id_his) REFERENCES historiales_pacientes(id_his) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2309 (class 2606 OID 31556)
-- Dependencies: 2240 1757 1755
-- Name: tratamientos_pacientes_id_tra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: desarrollo_g
--

ALTER TABLE ONLY tratamientos_pacientes
    ADD CONSTRAINT tratamientos_pacientes_id_tra_fkey FOREIGN KEY (id_tra) REFERENCES tratamientos(id_tra) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2361 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-12-29 09:49:21

--
-- PostgreSQL database dump complete
--

