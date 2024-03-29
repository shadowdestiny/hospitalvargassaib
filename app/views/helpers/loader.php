<?php
    /**
     * @author Luis Marin
     * @name LoaderHelper
     * Fecha: 16/06/2011 11:21pm
     * Carga todo aquello que tenga que ver con algun elemento loading
     */
    class LoaderHelper extends AppHelper{
       /**
         * @author Luis Marin
         * @name DivPaginator
         * @return String Javascript
         * Fecha: 16/06/2011 11:21pm
         * Carga todo aquello que tenga que ver con algun elemento loading
         */
        function DivPaginator(){
            $jquery = "            
             var paginator_div = function(url){            
                    jQuery(\"#content\").html('<img id=\"cargador\" src=\"".$this->webroot."img/icon/load_list.gif\" style=\"margin-top: 120px;display: block;\">');
                    jQuery(\"#content\").load(url,function(){
                        jQuery(\"#cargador\").css(\"display\",\"none\");
                        
                               
                        jQuery(\"a[href*='/page:']\").click(function(event){
                            event.preventDefault();
                            var url = jQuery(this).attr(\"href\");
                            paginator_div(url);
                        });
                    });
                }
            ";
            return $jquery;
        }
        
         /**
         * @author Luis Marin
         * @name DivPaginatorPost
         * @return String Javascript
         * Fecha: 30/06/2011 11:21pm
         * Crea una funcion llamado "paginator_div" y 
         * Carga todo aquello que tenga que ver con algun 
         * elemento loading pasando parametros en forma de POST
         * @param Nota, si se van a identificar las ids
         * estas tendran que se limpias, ejem: sin # o cualquier
         * atributo de jquery.
         */
        function DivPaginatorPost($id_content = "content",$id_img_cargador = "cargador"){
            $jquery = "
                var paginator_div = function(url,form_object){
                    
                    jQuery(\"#$id_content\").html('<img id=\"$id_img_cargador\" src=\"".$this->webroot."img/icon/load_list.gif\" style=\"margin-top: 120px;display: block;\">');                           
                    jQuery.ajax({
                        type     : \"POST\",
                        url      : url,
                        data     : jQuery(form_object).serializeArray(),
                        datatype : \"HTML\",
                        success : function(_html){ 
                            jQuery(\"#$id_img_cargador\").css(\"display\",\"none\");
                            jQuery(\"#$id_content\").html(_html);
                            jQuery(\"a[href*='/page:']\").click(function(event){
                                
                                event.preventDefault();
                                var url = jQuery(this).attr(\"href\");
                                paginator_div(url,form_object);
                            });
                        }
                    });              
                }
            ";
            return $jquery;            
        }
    }
?>