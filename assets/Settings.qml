import bb.cascades 1.2
import Network.LoginController 1.0
import conf.SettingsController 1.0
import com.netimage 1.0

NavigationPane {
    id: navSettings
    property variant tpage
    property variant googlePage
    property variant dropboxPage
    property variant logPage
    signal done ()
    
	Page {
        id: settingsPage
        
        
        titleBar: TitleBar {
            title: qsTr("Settings")
            dismissAction: ActionItem {
                title: qsTr("Close")
                onTriggered: {
                    // Emit the custom signal here to indicate that this page needs to be closed
                    // The signal would be handled by the page which invoked it
                    navSettings.done();
                }
            }
            acceptAction: ActionItem {
                title: qsTr("Save")
                onTriggered: {
                    settingsController.save(); 
                    navSettings.done();
                }
            }
        }
        
        ScrollView {
            id: settingPage
            property string userName;
            
    	    Container {
    	        layout: StackLayout {
    	            orientation: LayoutOrientation.TopToBottom
    	        }
                id: headerContainer
                horizontalAlignment: HorizontalAlignment.Fill
    	        
                function themeStyleToHeaderColor(style){
                    switch (style) {
                        case VisualStyle.Bright:
                            return Color.create(0.96,0.96,0.96);
                        case VisualStyle.Dark: 
                            return Color.create(0.15,0.15,0.15);
                        default :
                            return Color.create(0.96,0.96,0.96);    
                    }
                    return Color.create(0.96,0.96,0.96); 
                }
    	        
                // --------------------------------------------------------------------------
                // Login settings
                
                Container {
                    minHeight: 100
                    maxHeight: 100
                }
                
                ImageView {
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    id: avatarOwnImg
                    scalingMethod: ScalingMethod.AspectFit
                    minHeight: 200
                    maxHeight: 200
                    minWidth: 200
                    maxWidth: 200
                    image: trackerOwn.image
                    
                    attachedObjects: [
                        NetImageTracker {
                            id: trackerOwn
                            
                            source: settingsController.avatar                                    
                        } 
                    ]
                }
                
    	        Label {
    	            id: userLabel
                    text: qsTr("User: ") + settingsController.userName
                    horizontalAlignment: HorizontalAlignment.Center
                }
    
    	        
    	        // Commit button
    	        Button {
    	            id: loginButton
    	            text: qsTr("Connect")
    	            horizontalAlignment: HorizontalAlignment.Fill
    	            onClicked: {
                        welcome.open();
    	            }
                    visible: (settingsController.userName == "")
    	        }
    	        
    	        
    	        Button {
    	            id: logOutButton
    	            text: qsTr("log out");
    	            horizontalAlignment: HorizontalAlignment.Fill
    	            onClicked: {
    	                loginController.logOut();
    	                loginButton.setVisible(true);
    	                logOutButton.setVisible(false);
                        userLabel.setText(qsTr("User: "));
    	            }
                    visible: (settingsController.userName != "")
    	        }
    	        
    	        Divider { }
    	        
                // --------------------------------------------------------------------------
                // Theme setting
                DropDown {
                    id: theme
                    title: qsTr("Visual Theme")
                    options: [
                        Option {
                            text: qsTr("Bright")
                            value: 1
                        },
                        Option {
                            text: qsTr("Dark")
                            value: 2
                        } 
                    ]
                    selectedIndex: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? 1 : 0
                    onSelectedOptionChanged: {
                        settingsController.theme = theme.selectedOption.value;
                    }
                
                } 
                
                DropDown {
                    id: fontSize
                    title: qsTr("Font size")
                    options: [
                        Option {
                            text: "25"
                            value: 25
                        },
                        Option {
                            text: "28"
                            value: 28
                        },
                        Option {
                            text: "31"
                            value: 31
                        },
                        Option {
                            text: "34"
                            value: 34
                        },
                        Option {
                            text: "37"
                            value: 37
                        },
                        Option {
                            text: "40"
                            value: 40
                        }
                    ]
                    selectedIndex: (settingsController.fontSize - 25) / 3
                    onSelectedOptionChanged: {
                        settingsController.fontSize = fontSize.selectedOption.value;
                    }
                    
                    
                }
                
    	        
    	        Divider { }
    	        
    	        Container {
    	            layout: DockLayout {
    	                
    	            }
    	            horizontalAlignment: HorizontalAlignment.Fill
    	            
    	            Label {
                        text: qsTr("Use dropbox to host files")
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Left
    	            }
    	            
    	            ToggleButton {
    	                id: useDropbox
                        checked: settingsController.useDropbox
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Right
                        
                        onCheckedChanged: {
                            settingsController.useDropbox = checked;
                        }
    	            }
    	            
    	        }
    	                            	        
                Button {
                    id: dropboxConnectButton
                    text: qsTr("Log to dropbox")
                    horizontalAlignment: HorizontalAlignment.Fill
                    onClicked: {
                        if(!dropboxPage)
                            dropboxPage = dropboxConnect.createObject();
                        navSettings.push(dropboxPage);
                    }
                }
                
                Divider { }
    	        
                Button {
                    id: clearHistory
                    text: qsTr("Clear history");
                    horizontalAlignment: HorizontalAlignment.Fill
                    onClicked: {
                        loginController.deleteHistory();
                    }
                }
                
                Button {
                    id: clearAudio
                    text: qsTr("Clear audio messages");
                    horizontalAlignment: HorizontalAlignment.Fill
                    onClicked: {
                        loginController.deleteAudioMessages();
                    }
                }
                
                Button {
                    id: clearvCard
                    text: qsTr("Clear stored contact information")
                    horizontalAlignment: HorizontalAlignment.Fill
                    onClicked: {
                        loginController.clearContactsData();
                    }
                }
                
                Divider { }
                Container {
                    layout: DockLayout { }
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    Label {
                        text: qsTr("Enable logs")
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Center
                    }
                
                    ToggleButton {
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Center
                        id: enableLogs
                        
                        checked: settingsController.enableLogs
                        onCheckedChanged: {
                            settingsController.enableLogs = checked;
                        }
                    }    
                }
                
                Button {
                    id: log
                    text: qsTr("Application Logs")
                    horizontalAlignment: HorizontalAlignment.Fill
                    onClicked: {
                        if(!logPage)
                            logPage = applicationLog.createObject();
                        navSettings.push(logPage);
                    }
                }
                
                Divider { }
                
    	    }
    	    
    	    
    	    attachedObjects: [
                LoginController {
                    id: loginController
                },
                SettingsController {
                    id: settingsController
                },
                ComponentDefinition {
                    id: googleConnect
                    source: "GoogleConnect.qml"
                },
                ComponentDefinition {
                    id: dropboxConnect
                    source: "DropboxConnect.qml"
                },
                ComponentDefinition {
                    id: facebookConnect
                    source: "FacebookConnect.qml"
                },
                ComponentDefinition {
                    id: applicationLog
                    source: "ApplicationLog.qml"
                }
            ]
    	    
            onUserNameChanged: {
                console.debug("name changed");
                userLabel.setText(qsTr("User: ") + settingsController.userName);
            }
    	}
    } 
	
	onCreationCompleted: {
        settingPage.userName =  settingsController.userName;
    }
	
	onPopTransitionEnded: {
	    
        userLabel.setText(qsTr("User: ") + settingsController.userName);
        loginButton.setVisible(!loginController.isLogged());
        logOutButton.setVisible(loginController.isLogged());
    }
	
}
