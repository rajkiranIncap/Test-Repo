({  
    getLoaded : function( component, event ) {
        var helper = this;
        var recordId = component.get( 'v.recordId' );
        var objectName = component.get("v.sObjectName");
        var fieldName = '';
		

        var description = component.get("v.description");
        helper.getRelatedFilesAsync( component, recordId , objectName, fieldName, recordId, false )
            .then( $A.getCallback( function( response ) {
                helper.applyFileTypeIconNames( component, response.files );
                component.set( 'v.selectedFiles', response.files );
                return response;

            })).then( function() {
                $A.util.addClass( component.find( 'init-spinner' ), 'slds-hide' );
            }).catch(function(error){
                console.error(error);
            });
    },
    getBaseURL : function(component, event){
        return this.enqueueAction( component, 'c.getBaseUrl', {
        }, {

            'background' : false,
            'storable' : false

        }).then( $A.getCallback( function( baseURL ) {

            return {
                'baseURL' : baseURL
            };

        }));
    },
    getRelatedFilesAsync : function( component, recordId, objectName, fieldName, fieldValue, background ) {
        var helper = this;

        return helper.enqueueAction( component, 'c.getRelatedFiles', {

            'entityIds' : recordId
        }, {

            'background' : background,
            'storable' : false

        }).then( $A.getCallback( function( files ) {

            return {
                'files' : files
            };

        }));

    },

    applyFileTypeIconNames : function( component, files ) {
        for ( var i = 0; i < files.length; i++ ) {

            var iconName = 'doctype:attachment';
            var file = files[i];

            if ( /^POWER_POINT/i.test( file.FileType ) ) {
                iconName = 'doctype:ppt';
            }
            else if ( /^EXCEL/i.test( file.FileType ) ) {
                iconName = 'doctype:excel';
            }
            else if ( /^WORD/i.test( file.FileType ) ) {
                iconName = 'doctype:word';
            }
            else if ( /^(MP3|WAV|M4A)/i.test( file.FileType ) ) {
                iconName = 'doctype:audio';
            }
            else if ( /^MP4/i.test( file.FileType ) ) {
                iconName = 'doctype:mp4';
            }
            else if ( /^CSV/i.test( file.FileType ) ) {
                iconName = 'doctype:csv';
            }
            else if ( /^TEXT/i.test( file.FileType ) ) {
                iconName = 'doctype:txt';
            }
            else if ( /^PDF/i.test( file.FileType ) ) {
                iconName = 'doctype:pdf';
            }
            else if ( /^XML/i.test( file.FileType ) ) {
                iconName = 'doctype:xml';
            }
            else if ( /^ZIP/i.test( file.FileType ) ) {
                iconName = 'doctype:zip';
            }
            else if ( /^(PNG|GIF|JPG|JPEG|TIFF|BMP)/i.test( file.FileType ) ) {
                iconName = 'doctype:image';
            }
            else if ( /^PACK/i.test( file.FileType ) ) {
                iconName = 'doctype:pack';
            }
            else if ( /^(MOV|WMV|M4V)/i.test( file.FileType ) ) {
                iconName = 'doctype:movie';
            }
            else if ( /^LINK/i.test( file.FileType ) ) {
                iconName = 'doctype:link';
            }
            else if ( /^HTML/i.test( file.FileType ) ) {
                iconName = 'doctype:html';
            }
            else if ( /^SNOTE/i.test( file.FileType ) ) {
                iconName = 'doctype:stypi';
            }

            file.FileTypeIconName = iconName;

        }

    },

    showSpinner : function( component ) {

        $A.util.removeClass( component.find( 'spinner' ), 'slds-hide' );

    },

    hideSpinner : function( component ) {

        $A.util.addClass( component.find( 'spinner' ), 'slds-hide' );

    },
    enqueueAction : function( component, actionName, params, options ) {

        var helper = this;

        var p = new Promise( function( resolve, reject ) {

            helper.showSpinner( component );

            var action = component.get( actionName );

            if ( params ) {
                action.setParams( params );
            }

            if ( options ) {
                if ( options.background ) { action.setBackground(); }
                if ( options.storable )   { action.setStorable(); }
            }

            action.setCallback( helper, function( response ) {
                helper.hideSpinner( component );

                if ( component.isValid() && response.getState() === 'SUCCESS' ) {

                    resolve( response.getReturnValue() );

                } else {

                    console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );

                    helper.logActionErrors( response.getError() );

                    reject( response.getError() );

                }
            });

            $A.enqueueAction( action );

        });

        return p;
    },

    logActionErrors : function( errors ) {
        if ( errors ) {
            if ( errors.length > 0 ) {
                for ( var i = 0; i < errors.length; i++ ) {
                    console.error( 'Error: ' + errors[i].message );
                }
            } else {
                console.error( 'Error: ' + errors );
            }
        } else {
            console.error( 'Unknown error' );
        }
    }
})