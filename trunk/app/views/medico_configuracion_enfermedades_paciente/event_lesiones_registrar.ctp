<table style="margin-left: 20px;">
    <tr>
        <td class="standar_font_sub" colspan="2">
            <?php __("Lesiones")?>
        </td>
    </tr>
    <?php
        foreach($les_cat as $row){
            ?>
                <tr>
                    <td>
                        <input class="standar_input_checkbox" type="checkbox" name="les_" value="(<?php echo $row->id_cat_cue_les.";".$id_par_cue_cat_cue?>)">
                    </td>
                    <td class="standar_font">
                        <?php echo $row->nom_les?>
                    </td>
                </tr>
            <?php
        }
    ?>
</table>