﻿<?php echo $this->Html->docType("html4-trans"); ?>
<html>
    <head>
        <?php echo $html->charset(); ?>
        <title>
            <?php echo __("Sistema de integración de las enfermedades dermatologicas"); ?>
           	<?php echo $scripts_for_layout;?>
        </title>        
       	<?php echo $this->Html->css('top_menu');?>
        <?php echo $this->Html->css('font');?>
        <?php echo $this->Html->css('standar');?>
        <?php echo $this->Html->css('menu_top');?>        
        <!-- Css acordion -->
         <link rel="stylesheet" type="text/css" href="<?php echo $this->webroot."js/jquery/jquery-ui-1.8.11.custom/css/cupertino/jquery-ui-1.8.11.custom.css"?>" />
         
        <!-- Css validator-->
         <link rel="stylesheet" type="text/css" href="<?php echo $this->webroot."js/jquery-validate.password/jquery.validate.password.css"?>" />      
        
        <?php #echo $this->Html->script("jquery/jquery-1.5.2.js"); ?>
        <?php echo $this->Html->script("jquery/jquery-1.5.1.min.js"); ?>                            
        <?php echo $this->Html->script("jquery/jquery-validation-1.8.0/jquery.validate.min.js"); ?>        
        <?php echo $this->Html->script("jquery/jquery-validation-1.8.0/localization/messages_es.js"); ?>                                  
        <?php echo $this->Html->script("jquery/jquery-ui-1.8.11.custom/js/jquery-ui-1.8.11.custom.min.js"); ?>
                
               
        
        <?php echo $scripts_for_layout; ?>       
        
        <!-- Css Modificacion de librerias -->
        <?php echo $this->Html->css('ui_jquery');?>
    </head>
    <body style="margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px; background-color: #EAF8F8; padding: 0;top: 0;">         
        <?php echo $content_for_layout ?>                                           
    </body>
</html>