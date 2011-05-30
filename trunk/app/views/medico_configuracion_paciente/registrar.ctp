<script type="text/javascript">
    jQuery(function() {
        //jQuery("body:eq(0)").css('background-color','black');
        //jQuery("body").removeClass('');
        // Accordion
        jQuery("#accordion").accordion({
            header: "h3"
        });
        // Tabs
        jQuery('#tabs').tabs();
        // Dialog			
        jQuery('#dialog').dialog({
            autoOpen: false,
            width: 600,
            buttons: {
                "Ok": function() {
                    jQuery(this).dialog("close");
                },
                "Cancel": function() {
                    jQuery(this).dialog("close");
                }
            }
        });

        // Dialog Link
        jQuery('#dialog_link').click(function() {
            jQuery('#dialog').dialog('open');
            return false;
        });

        // Datepicker
        jQuery('#datepicker').datepicker({
            inline: true
        });

        // Slider
        jQuery('#slider').slider({
            range: true,
            values: [17, 67]
        });

        // Progressbar
        jQuery("#progressbar").progressbar({
            value: 20
        });

        //hover states on the static widgets
        jQuery('#dialog_link, ul#icons li').hover(
        function() {
            jQuery(this).addClass('ui-state-hover');
        },
        function() {
            jQuery(this).removeClass('ui-state-hover');
        });
    });
</script>
<style type="text/css">
    .ui-widget{
        font-weight: normal;
    }
</style>
<div id="tabs" style="height: 390px;">
    <ul>
        <li>
            <a href="#tabs-1">                
                <?php echo __("Nuevo Paciente",true)?>
            </a>
        </li>
        <li>
            <a href="#tabs-2">
                <?php echo __("Evaluación Consulta",true)?>                
            </a>
        </li>
        <li>
            <a href="#tabs-3">
                <?php echo __("Evolución Tratamiento",true)?>                
            </a>
        </li>
        <li>
            <a href="#tabs-4">
                <?php echo __("Muestra Clinica",true)?>                  
            </a>
        </li>
    </ul>
    <!--Inicio de la pestaña "tabs-1" -->
    <div id="tabs-1">
       
        <fieldset style="height: 310px;">
            <legend>
                <strong class="standar_font_sub">
                    <?php echo __("Agregar Datos Personales del Paciente",true)?>                   
                </strong>
            </legend>
            <form id="for_Pac" name="for_Pac" method="post" action="null" onSubmit="return false">
                <table width="540" border="0" align="center" bgcolor="" cellpadding="0"
                cellspacing="0">
                    <tr>
                        <td width="184" class="standar_font">
                            <?php echo __("Nombre",true)?>                              
                        </td>
                        <td width="9" class="standar_font">
                            &nbsp;
                        </td>
                        <td width="189" class="standar_font">
                            <?php echo __("Apellido",true)?>                            
                        </td>
                        <td width="8 class="standar_font"">
                            &nbsp;
                        </td>
                        <td width="144" class="standar_font">
                            <?php echo __("Cédula de Identidad",true)?>                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="tex_pac_nom" value="" class="textos" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input type="text" name="tex_pac_ape" value="" class="textos" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input type="text" name="tex_pac_ced" value="" class="textos" />
                        </td>
                    </tr>
                    <tr>
                        <td class="standar_font">                            
                            <?php echo __("Fecha de Nacimiento",true)?>
                        </td>
                        <td class="standar_font">
                            &nbsp;
                        </td>
                        <td class="standar_font">
                            <?php echo __("Edad",true)?>                            
                        </td>
                        <td class="standar_font">
                            &nbsp;
                        </td>
                        <td class="standar_font">
                            <?php echo __("Ocupación",true)?>                                                       
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="tex_pac_fec" value="" class="textos" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input type="text" name="tex_pac_eda" value="" class="textos" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <select id="sel_pac_ocu" name="sel_pac_ocu" value="" class="textos">                               
                                <option>
                                    <?php echo __("Profesional",true)?>                                                               
                                </option>
                                <option>
                                    <?php echo __("Tecnico",true)?>                                    
                                </option>
                                <option>
                                    <?php echo __("Obrero",true)?>                                    
                                </option>
                                <option>
                                    <?php echo __("Agricultor",true)?>                                    
                                </option>
                                <option>
                                    <?php echo __("Jardinero",true)?>                                    
                                </option>
                                <option>
                                    <?php echo __("Otro",true)?>                                    
                                </option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="standar_font">
                            Estado
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            Municipio
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            Parroquia
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select id="sel_pac_ciu" name="sel_pac_ciu" value="" class="textos">
                                <?php 
                                    foreach($estados as $row){
                                        ?>
                                            <option value="<?php echo $row->id_est?>"><?php echo $row->des_est?></option>
                                        <?php
                                    }
                                ?>
                            </select>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input type="text" name="tex_pac_mun" id="tex_pac_mun" value="" class="textos"
                            />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input type="text" name="tex_pac_par" id="tex_pac_par" value="" class="textos"
                            />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <?php echo __("Referido Por",true)?>:                            
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <?php echo __("Nombre del Medico",true)?>:
                            
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            Tipo de Consulta
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select id="sel_pac_ref" name="sel_pac_ref" class="textos">                                
                                <option>
                                    Hospital General
                                </option>
                                <option>
                                    Hospital Universitario
                                </option>
                                <option>
                                    Hospital Especializado
                                </option>
                                <option>
                                    Ambulatorio Urbano
                                </option>
                                <option>
                                    Ambulatorio Rural
                                </option>
                                <option>
                                    Insituto
                                </option>
                                <option>
                                    Clinica
                                </option>
                                <option>
                                    Dispensario
                                </option>
                                <option>
                                    Barrio Adentro I
                                </option>
                                <option>
                                    Barrio Adentro II
                                </option>
                                <option>
                                    Barrio Adentro III
                                </option>
                                <option>
                                    Otros
                                </option>
                            </select>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input type="text" name="tex_pac_nom6" value="" class="textos" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <select id="sel_pac_con" name="sel_pac_con" class="textos">
                                <option>
                                    Consulta
                                </option>
                                <option>
                                    Dermatologia
                                </option>
                                <option>
                                    Pediatria
                                </option>
                                <option>
                                    Neumologia
                                </option>
                                <option>
                                    Consulta Interna
                                </option>
                                <option>
                                    Geriatria
                                </option>
                                <option>
                                    Urologia
                                </option>
                                <option>
                                    Infectologia
                                </option>
                            </select>
                        </td>
                    </tr>
                </table>
            </form>
        </fieldset>
    </div>
    <!--Final de la pestaña "tabs-1" -->
    <!--Inicio de la pestaña "tabs-2" -->
    <div id="tabs-2">
        <h2 class="texPrincipal">
            Evaluación del Tipo de Consulta
        </h2>
        <fieldset>
            <legend>
                <strong>
                    Contacto con:
                </strong>
            </legend>
            <form id="for_Eva" name="for_Eva" method="post" action="">
                <table width="142" border="0" cellpadding="0" cellspacing="0" align="center">
                    <tr>
                        <td width="29" class="titulos style2" style="font-size: 12px;">
                            <div align="right">
                                Perro
                            </div>
                        </td>
                        <td width="20">
                            <input type="checkbox" name="che_eva_per" id="che_eva_per" class="textos"
                            />
                        </td>
                        <td width="31">
                            &nbsp;
                        </td>
                        <td width="30" class="titulos style2" style="font-size: 12px;">
                            <div align="right">
                                Gato
                            </div>
                        </td>
                        <td width="20">
                            <input type="checkbox" name="che_eva_gat" id="che_eva_gat" class="textos"
                            />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="titulos style2" style="font-size: 12px;">
                            <div align="right">
                                Aves
                            </div>
                        </td>
                        <td>
                            <input type="checkbox" name="che_eva_ave" id="che_eva_ave" class="textos"
                            />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td class="titulos style2" style="font-size: 12px;">
                            <div align="right">
                                Corral
                            </div>
                        </td>
                        <td>
                            <input type="checkbox" name="che_eva_cor" id="che_eva_cor" class="textos"
                            />
                        </td>
                    </tr>
                </table>
                <table width="100" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="font-size: 12px;">
                            <div align="right">
                                Especifique:
                            </div>
                        </td>
                        <td>
                            <textarea name="tex_eva_esp" id="tex_eva_esp" cols="35" rows="2" class="textos">
                            </textarea>
                        </td>
                    </tr>
                </table>
            </form>
        </fieldset>
    </div>
    <!--Final de la pestaña "tabs-2" -->
    <!--Inicio de la pestaña "tabs-3" -->
    <div id="tabs-3">
        <h2 class="texPrincipal">
            Tiempo de Evoluci&oacute;n
        </h2>
        <fieldset>
            <legend>
                <strong>
                    Tiempo:
                </strong>
            </legend>
            <!--Formulario de fecha JQUERY-->
            <center>
                <form>
                    <div class="demo">
                        <p>
                            Fecha:
                            <input type="text" id="datepicker" name="datepicker">
                        </p>
                    </div>
                    <script language="JavaScript" type="text/javascript">
                       // < !--fooCalendar = new dynCalendar('fooCalendar', 'calendarCallback', 'Librerias/Calendario/images/'); //-->
                        
                    </script>
                </form>
            </center>
        </fieldset>
        <!--Fin del Formulario de fecha JQUERY-->
        <p>
            <fieldset>
                <legend>
                    <strong>
                        Antecedentes personales o Factores predisponentes:
                    </strong>
                </legend>
                <form id="for_Ant" name="for_Ant" method="post" action="">
                    <table width="443" border="0" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td width="180" style="font-size: 12px;">
                                <div align="right">
                                    Obesidad
                                </div>
                            </td>
                            <td width="21">
                                <div align="center">
                                    <input type="checkbox" name="che_ant_obe" id="che_ant_obe" />
                                </div>
                            </td>
                            <td width="6">
                                &nbsp;
                            </td>
                            <td width="110" style="font-size: 12px;">
                                <div align="right">
                                    Diabetes
                                </div>
                            </td>
                            <td width="20">
                                <div align="center">
                                    <input type="checkbox" name="che_ant_dia" id="che_ant_dia" />
                                </div>
                            </td>
                            <td width="6">
                                &nbsp;
                            </td>
                            <td width="79" style="font-size: 12px;">
                                <div align="right">
                                    Traumatismo
                                </div>
                            </td>
                            <td width="21">
                                <div align="center">
                                    <input type="checkbox" name="che_ant_tra" id="che_ant_tra" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Cirug&iacute;a
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_cir" id="che_ant_cir" />
                                </div>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    HIV/SIDA
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_hiv" id="che_ant_hiv" />
                                </div>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    C&aacute;ncer
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_can" id="che_ant_can" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Inmunosupresi&oacute;n/Neutropenia
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_inm" id="che_ant_inm" />
                                </div>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Esteroides
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_est" id="che_ant_est" />
                                </div>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Embarazo
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_emb" id="che_ant_emb" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Neoplasias
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_neo" id="che_ant_neo" />
                                </div>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Inanici&oacute;n
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_ina" id="che_ant_ina" />
                                </div>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td style="font-size: 12px;">
                                <div align="right">
                                    Otra
                                </div>
                            </td>
                            <td>
                                <div align="center">
                                    <input type="checkbox" name="che_ant_otr" id="che_ant_otr" />
                                </div>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <table width="443" border="0" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td width="216" style="font-size: 12px;">
                                <div align="right">
                                    Especifique:
                                </div>
                            </td>
                            <td width="227">
                                <label>
                                    <textarea name="tex_ant_esp" id="tex_ant_esp" cols="35" rows="2">
                                    </textarea>
                                </label>
                            </td>
                        </tr>
                    </table>
                </form>
            </fieldset>
            <p>
                <fieldset>
                    <legend>
                        <strong>
                            Tratamiento previo:
                        </strong>
                    </legend>
                    <form id="for_Tra" name="for_Tra" method="post" action="">
                        <table width="443" border="0" cellpadding="0" cellspacing="0" align="center">
                            <tr>
                                <td width="180" style="font-size: 12px;">
                                    <div align="right">
                                        Antimic&oacute;ticos
                                    </div>
                                </td>
                                <td width="21">
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_ant" id="che_tra_ant" />
                                    </div>
                                </td>
                                <td width="6">
                                    &nbsp;
                                </td>
                                <td width="110" style="font-size: 12px;">
                                    <div align="right">
                                        Antibi&oacute;ticos
                                    </div>
                                </td>
                                <td width="20">
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_anti" id="che_tra_anti" />
                                    </div>
                                </td>
                                <td width="6">
                                    &nbsp;
                                </td>
                                <td width="79" style="font-size: 12px;">
                                    <div align="right">
                                        T&oacute;picos
                                    </div>
                                </td>
                                <td width="21">
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_top" id="che_tra_top" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Inmunosupresores
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_inm" id="che_tra_inm" />
                                    </div>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Glucorticoides
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_glu" id="che_tra_glu" />
                                    </div>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Citot&oacute;xicos
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_cit" id="che_tra_cit" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Hormonas sexuales
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_hor" id="che_tra_hor" />
                                    </div>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Radioterapia
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_rad" id="che_tra_rad" />
                                    </div>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Sist&eacute;micos
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_sist" id="che_tra_sist" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 12px;">
                                    <div align="right">
                                        Otra
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <input type="checkbox" name="che_tra_otr" id="che_tra_otr" />
                                    </div>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                        <table width="443" border="0" cellpadding="0" cellspacing="0" align="center">
                            <tr>
                                <td width="216" style="font-size: 12px;">
                                    <div align="right">
                                        Especifique:
                                    </div>
                                </td>
                                <td width="227">
                                    <label>
                                        <textarea name="tex_tra_esp" id="tex_tra_esp" cols="35" rows="2">
                                        </textarea>
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </form>
                </fieldset>
    </div>
    <!--Final de la pestaña "tabs-3" -->
    <!--Inicio de la pestaña "tabs-4" -->
    <div id="tabs-4">
        <h2 class="texPrincipal">
            Muestra Clinica
        </h2>
        <fieldset>
            <legend>
                <strong>
                    Muestra a Procesar:
                </strong>
            </legend>
            <form id="for_Mue" name="for_Mue" method="post" action="">
                <table width="443" border="0" cellpadding="0" cellspacing="0" align="center">
                    <tr>
                        <td width="136">
                        </td>
                        <td width="307">
                            <ul>
                                <label>
                                    <span class="titulos">
                                        <select id="sel_pac_mue" name="sel_pac_mue" class="textos">
                                            <option>
                                                Muestra a Procesar
                                            </option>
                                            <option>
                                                Aspira ocular
                                            </option>
                                            <option>
                                                Aspirado traqueal
                                            </option>
                                            <option>
                                                Biopsia otros órganos
                                            </option>
                                            <option>
                                                Biopsia piel
                                            </option>
                                            <option>
                                                Catéteres diálisis peritoneal
                                            </option>
                                            <option>
                                                Catéteres intravascular
                                            </option>
                                            <option>
                                                Cateterismo
                                            </option>
                                            <option>
                                                Cavidad oral
                                            </option>
                                            <option>
                                                Cepillado protegido
                                            </option>
                                            <option>
                                                Escama
                                            </option>
                                            <option>
                                                Esputo espontaneo
                                            </option>
                                            <option>
                                                Esputo inducido
                                            </option>
                                            <option>
                                                Exudado
                                            </option>
                                            <option>
                                                Exudado conjuntival
                                            </option>
                                            <option>
                                                Exudado nasal
                                            </option>
                                            <option>
                                                Exudado vaginal
                                            </option>
                                            <option>
                                                Haces
                                            </option>
                                            <option>
                                                Lavado bronquial
                                            </option>
                                            <option>
                                                Lentes de contacto
                                            </option>
                                            <option>
                                                Liquido cefalorraquídeo (LCR)
                                            </option>
                                            <option>
                                                Liquido peritoneal
                                            </option>
                                            <option>
                                                Liquido pleural
                                            </option>
                                            <option>
                                                Liquido sinovial
                                            </option>
                                            <option>
                                                Medula Ósea
                                            </option>
                                            <option>
                                                Muestra ópticas
                                            </option>
                                            <option>
                                                Orina
                                            </option>
                                            <option>
                                                Pelos
                                            </option>
                                            <option>
                                                Prótesis
                                            </option>
                                            <option>
                                                Puntación pleural
                                            </option>
                                            <option>
                                                Raspado corneal
                                            </option>
                                            <option>
                                                Sangre
                                            </option>
                                            <option>
                                                Uñas
                                            </option>
                                            <option>
                                                Otros
                                            </option>
                                        </select>
                                    </span>
                                </label>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <ul>
                                <div align="right">
                                    Especifique:
                                </div>
                            </ul>
                        </td>
                        <td>
                            <ul>
                                <textarea name="tex_tra_esp" id="tex_tra_esp" cols="35" rows="2">
                                </textarea>
                            </ul>
                        </td>
                    </tr>
                </table>
            </form>
        </fieldset>
    </div>
    <!--Final de la pestaña "tabs-4" -->
</div>