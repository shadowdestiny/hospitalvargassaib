    <?php
    
    ?>
    
    
<table style="width: 450px;" align="center">
    <tr class="">
        <td align="center" class="standar_font lista_fondo">
            #
        </td>
        <td align="center" class="standar_font lista_fondo">
            <?php __("Login")?>
        </td>
        <td align="center" class="standar_font lista_fondo">
            <?php __("Nombre")?>
        </td>
        <td align="center" class="standar_font lista_fondo">
            <?php __("Apellido")?>
        </td>
        <td align="center" class="standar_font lista_fondo">
            <?php __("Modificar")?>
        </td>
        <td align="center" class="standar_font lista_fondo">
            <?php __("Eliminar")?>
        </td>        
    </tr>

<?php    

    $i = 0;
    foreach ($results as $row){
        $i ++;
        ?>
            <tr>
                <td class="standar_font"><?php echo $i ?></td>
                <td class="standar_font"><?php echo $row->log_doc ?></td>
                <td class="standar_font"><?php echo $row->nom_doc ?></td>
                <td class="standar_font"><?php echo $row->ape_doc ?></td>
                <td class="standar_font" align="center"><a onclick="edit('<?php echo $row->id_doc?>')" href="javascript:void(0)" class="border"><img title="<?php echo __("Modificar usuario médico",true)." ".$row->log_doc?>" class="border" src="<?php echo $this->webroot?>/img/icon/page_white_edit.png"></a></td>
                <td class="standar_font" align="center"><a onclick="del('<?php echo $row->id_doc?>','<?php echo $row->log_doc?>')" href="javascript:void(0)" class="border"><img title="<?php echo __("Eliminar usuario médico",true)." ".$row->log_doc?>" class="border" src="<?php echo $this->webroot?>/img/icon/cancel.png"></a></td>
            </tr>        
        <?php
    }
?>
</table>