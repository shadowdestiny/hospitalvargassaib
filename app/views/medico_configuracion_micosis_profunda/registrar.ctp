	   <script type="text/javascript">
		<!--Funciones de JQUERY-->
			jQuery(function(){

				// Accordion
				jQuery("#accordion").accordion({ header: "h3" });
	
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
				jQuery('#dialog_link').click(function(){
					jQuery('#dialog').dialog('open');
					return false;
				});

				//hover states on the static widgets
				jQuery('#dialog_link, ul#icons li').hover(
					function() { jQuery(this).addClass('ui-state-hover'); }, 
					function() { jQuery(this).removeClass('ui-state-hover'); }
				);
				
			});
		</script>
			
	    
	
           <div id="tabs">
			<ul>
				<li><a href="#tabs-1">Descripción</a></li>
				<li><a href="#tabs-2">Estudio Micol&oacute;gico</a></li>
			    <li><a href="#tabs-3">Inmunodiagnostico</a></li>
                <li><a href="#tabs-4">Serologia por (IDD)</a></li>
                <li><a href="#tabs-5">Elisa</a></li>
                <li><a href="#tabs-6">Estudio Molecular</a></li>
			</ul>
			
    
<!--Inicio de la pestaña "tabs-1" -->    	 
<div id="tabs-1">
	<h2 class="texPrincipal">Evaluar Micosis Profunda</h2>
    
  
  <fieldset>	   
    <legend>
    		<strong>
    			Descripción de la lesión:
    		</strong>    
   	</legend>   
    <!--<form>
    <center>
      <p>      </p>
      <table width="364" border="0">
        <tr>
          <td width="182">
          <h3 class="texSecundario">
          <fieldset>
          <legend>Tipo de Infección</legend>
          <p align="center">
          <select id="sel_pac_ref" name="sel_pac_ref" class="textos">
          <option> Actinomicetoma </option>
            <option> Cromoblastomicos </option>
            <option> Esporotricosis </option>
            <option> Eumicetoma </option>
            <option> Lobomicosis </option>
        </select>
        </p>
          </fieldset>
        </h3>          </td>
          <td width="166">
          <h3 class="texSecundario">
          <fieldset>
          <legend>Forma de Infección</legend>
          <p align="center">
          
          <select id="sel_pac_ref" name="sel_pac_ref" class="textos">
          <option> Actinomicetoma </option>
            <option> Cromoblastomicos </option>
            <option> Esporotricosis </option>
            <option> Eumicetoma </option>
            <option> Lobomicosis </option>
        </select>
          </p>
          </fieldset>
          </h3>          </td>
        </tr>
      </table>
    </center>
    </form>-->
    <form action="" method="get">
    <table width="474" border="0" align="center">
  <tr>
    <td width="237">
    <fieldset>
    <legend><strong>Descripci&oacute;n:</strong></legend>
    <table width="235" border="0">
  <tr>
    <td width="20"><label>
      <input type="checkbox" name="che_cut" id="che_cut">
    </label></td>
    <td width="200">Cut&aacute;nea</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_pul" id="che_pul"></td>
    <td>Pulmonar</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_pul_lev" id="che_pul_lev"></td>
    <td>Pulmonar leve</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_pul_mod" id="che_pul_mod"></td>
    <td>Pulmonar moderada</td>
  </tr>
  
  <tr>
    <td><input type="checkbox" name="che_pul_agu" id="che_pul_agu"></td>
    <td>Pulmonar aguda</td>
  </tr>
  
  
  <tr>
    <td><input type="checkbox" name="che_pul_cro" id="che_pul_cro"></td>
    <td>Pulmonar cr&oacute;nica benigna</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_pul_pro" id="che_pul_pro"></td>
    <td>Pulmonar progresiva</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_dis" id="che_adis"></td>
    <td>Diseminada</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_teg" id="che_teg"></td>
    <td>Tegumentaria (mucocut&aacute;nea)</td>
  </tr>
</table>
    </fieldset>    </td>
    <td width="237">
    <fieldset>
    <legend><strong>Descripci&oacute;n:</strong></legend>
   <table width="235" border="0">
  <tr>
    <td width="25"><label>
      <input type="checkbox" name="che_gan" id="che_gan">
    </label></td>
    <td width="200">Ganclionar</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_vic" id="che_vic"></td>
    <td>Visceral</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_mix" id="che_mix"></td>
    <td>Mixta</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_men" id="che_men"></td>
    <td>Men&iacute;ngea</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_hep" id="che_hep"></td>
    <td>Hepatoesplenomegalia</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_gen" id="che_gen"></td>
    <td>Generalizada</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_hit" id="che_hit"></td>
    <td>Hitoplasmoma</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="che_otr" id="che_otr"></td>
    <td>Otra</td>
  </tr>
  <tr>
    <td height="20">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
    </fieldset>    
    </td>
  </tr>
</table>
</form>
  </fieldset>         
           
   <fieldset>	   
      <legend>
    		<strong>
    			Modo de Infección:
    		</strong>    
   	  </legend>
        
      <form action="" method="get" style="text-align:center">
        
        <select name="">
        <option>-- --</option>
        <option>Inhalación</option>
        <option>Traumática</option>
        <option>Accidente de Laboratorio</option>
        </select>
        
      </form>  
   </fieldset>
     
</div>
<!--Final de la pestaña "tabs-1" -->
          
    
<!--Inicio de la pestaña "tabs-2" -->    
<div id="tabs-2">
    
	<h2 class="texPrincipal">Examen Directo y de Cultivo</h2>
    
  
  <fieldset>	
    
	<legend>
    		<strong>
	Examen:    		</strong>    	</legend>
    <form action="" method="get">
    
    
    <table width="470" border="0" align="center">
      <tr>
        <td width="223"><fieldset>
          <legend><strong>Directo</strong></legend>
          <table width="221" height="122" border="0">
            <tr>
              <td width="20" height="22"><label>
                <input type="checkbox" name="che_Exa_Lev_Sim" id="che_Exa_Lev_Sim">
              </label></td>
              <td width="191">Levaduras Simples</td>
            </tr>
            <tr>
              <td height="22"><input type="checkbox" name="checkbox" id="checkbox2"></td>
              <td>Levaduras Multi</td>
            </tr>
            <tr>
              <td height="22"><input type="checkbox" name="checkbox" id="checkbox3"></td>
              <td>Esf&eacute;rulas pared doble</td>
            </tr>
            <tr>
              <td height="22"><input type="checkbox" name="checkbox" id="checkbox4"></td>
              <td>Levaduras Intracelulares</td>
            </tr>
            <tr>
              <td><input type="checkbox" name="checkbox" id="checkbox5"></td>
              <td>Otro</td>
            </tr>
          </table>
        </fieldset></td>
        <td width="237"><fieldset>
          <legend><strong>Cultivo</strong></legend>
          <table width="244" height="122" border="0">
            <tr>
              <td width="20" height="22"><label>
                <input type="checkbox" name="checkbox" id="checkbox">
              </label></td>
              <td width="214">Coccidioides posadasii</td>
            </tr>
            <tr>
              <td height="22"><input type="checkbox" name="checkbox" id="checkbox2"></td>
              <td>Histoplasma Capsulatum</td>
            </tr>
            <tr>
              <td height="22"><input type="checkbox" name="checkbox" id="checkbox3"></td>
              <td>Paracoccidioides Brasiliensis</td>
            </tr>
            <tr>
              <td height="22"><input type="checkbox" name="checkbox2" id="checkbox6"></td>
              <td>Otro</td>
            </tr>
            <tr>
              <td height="22">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
        </fieldset></td>
      </tr>
    </table>
    
    
    <fieldset>
   	  <legend>
    		<strong>
    			Agente Ailado
    		</strong>
   	  </legend>
        
        
        <table width="549" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="20"><input type="checkbox" name="checkbox7" id="checkbox7"></td>
    <td width="150"><div align="left">Coccidioides posadasii</div></td>
    <td width="20"><input type="checkbox" name="checkbox8" id="checkbox8"></td>
    <td width="150"><div align="left">Histoplasma Capsulatum</div></td>
    <td width="20"><input type="checkbox" name="checkbox9" id="checkbox9"></td>
    <td width="150"><div align="left">Paracoccidioides Brasiliensis</div></td>
  </tr>
</table>

    </fieldset>
    
    </form>
  </fieldset>         
            </div>
<!--Final de la pestaña "tabs-2" -->
            
<!--Inicio de la pestaña "tabs-3" -->            
<div id="tabs-3">
	<h2 class="texPrincipal">Inmunodiagnostico de Las Micosis Subcutaneas</h2>
    
  
<fieldset>	
    	<legend>
		<strong>
    			Lectura 24 y 48 horas:
		</strong>    
    	</legend>



        <table border="1" class="circular" align="center">
  <tr>
    <th>
<table border="0" cellpadding="0" cellspacing="0">
<tr>
<th width="160">&nbsp;</th>
<th width="90">0-4,99 mm</th>
<th width="90">5-7 MM</th>
<th width="90">8-15 MM</th>
<th width="90">&gt; 15MM</th> 
</tr>

<tr>
<th>Candidina</th>
<td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /> </td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>

<tr>
<th>ESPOROTRIQUINA</th>
<td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>
<tr>
  <th>LEISHMANINA</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>
<tr>
  <th>HISTOPLASMINA</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>
<tr>
  <th>COCCIDIODINA</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>
<tr>
  <th>PARACOCCIDIOIDINA</th>
 <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
 <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
 <td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
 <td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>
<tr>
  <th>PPD</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_3" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_4" value="radio" /></td>
</tr>
</table></th>
  </tr>
</table>



    </fieldset>         
    </div>
<!--Final de la pestaña "tabs-3" -->            

<!--Inicio de la pestaña "tabs-4" -->
<div id="tabs-4">
	<h2 class="texPrincipal">Inmunodiagnostico de Las Micosis Subcutaneas</h2>
    
  
<fieldset>	
    	<legend>
		<strong>
    			Lectura 24 y 48 horas:
		</strong>    
    	</legend>



       <table border="1" class="circular">
          <tr>
            <td>
 


  <table width="600" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="121">Antigenos</th>
    <th width="77">IDD</th>
    <th width="332">Titulo</th>
    <th width="73">Linea Iden</th>
  </tr>
</table>
		<table width="600"  border="0" cellpadding="0" cellspacing="0"> 
  <tr>
    <th width="200">&nbsp;</th>
    <th width="39">+</th>
    <th width="39">_</th>
    <th width="60">1:2</th>
    <th width="60">1:4</th>
    <th width="60">1:8</th>
    <th width="60">1:16</th>
    <th width="60">1:32</th>
    <th width="60">+1:32</th>
    <th width="39">Si</th>
    <th width="39">No</th>
    </tr>
  <tr>
    <th>Candida</th>
    <form name="form1" method="post" action="">
    <td class="fontd">
      <label>
        <input type="checkbox" name="checkbox10" id="checkbox10">
        </label>    </td>
    <td class="fontd">
          <label>
        <input type="checkbox" name="checkbox10" id="checkbox10">
        </label>    </td>
    </form>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>

    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>S. Schenckii</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>P. Brasiliensis</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>C. Posadasii</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>H. Capsulatum</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Aspergillus</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Criptococcus </th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
</table>

    
  

            
            
            
            
            
            
            </td>
          </tr>
        </table>
</fieldset>         
    </div>
<!--Final de la pestaña "tabs-4" -->            

<!--Inicio de la pestaña "tabs-5" -->
<div id="tabs-5">
	<h2 class="texPrincipal">Inmunodiagnostico de Las Micosis Subcutaneas</h2>
    
  
<fieldset>	
    	<legend>
		<strong>
    			Lectura 24 y 48 horas:
		</strong>    
    	</legend>


<table border="1" class="circular">
          <tr>
            <td>
 


  <table width="600" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <th width="121">Antigenos</th>
    <th width="77">IDD</th>
    <th width="332">Titulo</th>
    <th width="73">Linea Iden</th>
  </tr>
</table>
		<table width="600"  border="0" cellpadding="0" cellspacing="0"> 
  <tr>
    <th width="200">&nbsp;</th>
    <th width="39">+</th>
    <th width="39">_</th>
    <th width="60">1:2</th>
    <th width="60">1:4</th>
    <th width="60">1:8</th>
    <th width="60">1:16</th>
    <th width="60">1:32</th>
    <th width="60">+1:32</th>
    <th width="39">Si</th>
    <th width="39">No</th>
    </tr>
  <tr>
    <th>Candidiasis</th>
    <form name="form1" method="post" action="">
    <td class="fontd">
      <label>
        <input type="checkbox" name="checkbox10" id="checkbox10">
        </label>    </td>
    <td class="fontd">
          <label>
        <input type="checkbox" name="checkbox10" id="checkbox10">
        </label>    </td>
    </form>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>
    <td class="fontd"><input name="" type="radio" value="" /></td>

    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Esporotricosis</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Cromomicosis</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Histoplasmosis</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Paracoccidioidomicosis</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Coccidioidomicosis</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
  <tr>
    <th>Aspergil</th>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><input type="radio" name="radio" id="radio3" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio4" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio5" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio6" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio7" value="radio"></td>
    <td class="fontd"><input type="radio" name="radio" id="radio8" value="radio"></td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    <td class="fontd"><label>
      <input type="checkbox" name="checkbox10" id="checkbox10">
      </label>    </td>
    </tr>
</table>

    
  

            
            
            
            
            
            
            </td>
          </tr>
        </table>
        



    </fieldset>         
    </div>
<!--Final de la pestaña "tabs-5" -->            

<!--Inicio de la pestaña "tabs-6" -->
<div id="tabs-6">
	<h2 class="texPrincipal">Inmunodiagnostico de Las Micosis Subcutaneas</h2>
    
  
<fieldset>	
    	<legend>
		<strong>
    			Lectura 24 y 48 horas:
		</strong>    
    	</legend>



        <table border="1" class="circular" align="center">
  <tr>
    <th>
<table border="0" cellpadding="0" cellspacing="0">
<tr>
<th width="138">antigenos</th>
<th width="85">Positivo</th>
<th width="85">Negativo</th>
</tr>

<tr>
<th>Candidina</th>
<td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /> </td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
</tr>

<tr>
<th>Cryptococcus</th>
<td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
<td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
</tr>
<tr>
  <th>P. Brasiliensis</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  </tr>
<tr>
  <th>H. Capsulatum</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  </tr>
<tr>
  <th>S. Schenckii</th>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
  <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
  </tr>
<tr>
  <th>C. Posadasii</th>
 <td class="fontd"><input type="radio" name="rad_can" id="rad_1" value="radio" /></td>
 <td class="fontd"><input type="radio" name="rad_can" id="rad_2" value="radio" /></td>
 </tr>
</table></th>
  </tr>
</table>



    </fieldset>         
    </div>
<!--Final de la pestaña "tabs-6" -->            


</div> 