<?php if (count($enf_mic)==0){  ?>
    <span class="standar_font"><?php __("No existen registros actualmente")?></span>        
<?php die; } ?>   
<table border="0" style="margin-left: 10px;" cellspacing="0">    
    <?php foreach($enf_mic as $row):?>
        <tr>
            <td>
                <input type="checkbox" class="standar_input_checkbox" name="chk_enf_pac_" value="<?php echo $row->id_enf_mic?>" <?php echo $this->Otros->Attr($row->id_enf_mic,$row->nom_enf_mic,"txt_otr_enf_mic");?>> 
                     
            </td>
            <td align="left" class="standar_list">
                <?php echo $row->nom_enf_mic;?>
            </td>
        </tr> 
        <tr>
            <td colspan="2">
                <?php echo $this->Otros->Text(100, '');?>
            </td>
        </tr>   
    <?php endforeach; ?>
</table>