<?php
/*
-----------------------------------------------------------------------------------------------
ARCHIVO: contenido.ctp
DESCRIPCIÓN: Carga el gráfico y su tabulación
AUTOR: Lisseth Lozada
FECHA DE MODIFICACIÓN: 30/10/2011
SIGIS. C.A
-----------------------------------------------------------------------------------------------
*/
//die('$where_fec-->'.$where_fec.' $where_tm-->'.$where_tm);
?>
<script>
    jQuery(function(){ 
         parent.jQuery("#title_content").html("<?php echo $title;?>");
        jQuery.post("grafico",{fil_fec: "<?php print $where_fec;?>", fil_tm: "<?php print $where_tm;?>"},function(data){
            jQuery("#div_grafico_tip_mic").html(data);
            jQuery("#loading").css("display","none");
        },"html");
        
        jQuery.post("resumen",{fil_fec: "<?php print $where_fec;?>", fil_tm: "<?php print $where_tm;?>"},function(data){
            jQuery("#div_resumen_tip_mic").html(data);
            jQuery("#num_pac").html(jQuery("#scantidad").val());
        },"html");
    });
</script>
<table style="width:100%" align="center">
    <tr>
        <td class="standar_font" align="center">
            <?php __("A continuación se muestra una distribución de las enfermedades micológicas encontrados en <font style='color:red' id='num_pac'></font> pacientes comprendidos entre las fechas ");echo " <font style='color:blue'>$fec_ini</font> y <font style='color:red'>$fec_fin</font>"?>
        </td>
    </tr>
</table>
<div style="width: 100%;overflow-y: auto;height: 400px; ">
<table style="width:540px;overflow: auto; " border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
		<td style="text-align: center;height:110px;">
			<div id="div_resumen_tip_mic" style="text-align: center;"></div>
		</td>
	</tr>
    <tr><td height="20px"></td></tr>
    <tr>
        <td style="text-align: center;height:230px;vertical-align: center;">
            <img id="loading" src="<?php echo $this->webroot?>img/icon/load_list.gif"/>
            <div id="div_grafico_tip_mic" style="text-align: center;" ></div>
        </td>
    </tr>
    <tr><td height="20px"></td></tr>
    <tr>
		<td colspan="6">
			<table align="center" border="0" cellspacing="0" cellpadding="5" border="1">
				<tr>
					<td>					
						<input name="btn_volver" type="button" value=" <?php print __('Volver',true); ?>" onclick="history.back()">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>