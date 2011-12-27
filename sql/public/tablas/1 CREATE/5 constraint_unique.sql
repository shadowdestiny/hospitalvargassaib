﻿ALTER TABLE enfermedades_pacientes
	ADD CONSTRAINT enfermedades_pacientes_unique UNIQUE (id_enf_mic,id_tip_mic_pac);

ALTER TABLE tipos_micosis_pacientes__tipos_estudios_micologicos
	ADD CONSTRAINT tipos_micosis_pacientes__tipos_estudios_micologicos_unique UNIQUE(id_tip_mic_pac,id_tip_est_mic);

ALTER TABLE categorias_cuerpos__lesiones
	ADD CONSTRAINT categorias_cuerpos__lesiones_unique UNIQUE (id_les,id_cat_cue);