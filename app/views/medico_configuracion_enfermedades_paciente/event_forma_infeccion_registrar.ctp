<?php if (count($forma_infeccion)==0){  ?>
    <div class="standar_not_register">
        <span class="standar_not_register"><?php echo __("Esta enfermedad no contiene formas de infección asociadas",true)?></span>
    </div>            
<?php die; } ?>   
<table border="0" style="margin-left: 10px;margin-top: 5px;">
    <tr>
        <td>
            &nbsp;
        </td>
        <td class="standar_font_sub">
            <?php __("Forma de Infección")?>
        </td>        
    </tr>      
    <?php foreach($forma_infeccion as $row):?>      
        <tr>
            <td>
                <input type="checkbox" class="standar_input_checkbox" name="chk_for_inf_" value="<?php echo $row->id_for_inf?>" >        
            </td>
            <td align="left" class="standar_list">
                <?php echo $row->des_for_inf; ?>
            </td>            
        </tr>    
    <?php endforeach; ?>
</table>