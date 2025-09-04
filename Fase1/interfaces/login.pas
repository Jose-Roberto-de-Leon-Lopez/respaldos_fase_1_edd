unit login;

interface 

procedure Mostrarlogin;

implementation 

uses 
 gtk2, glib2, gdk2,
 homeRoot, homeUser, Crear_Cuenta, 
 variables, simpleLinkedList,interfaceTools;

var 
    entryUser, entryPass: PGtkWidget;
    loginWindow: PGtkWidget;

// Iniciar sesión
procedure OnLoginButtonClick(widget: PGtkWidget; data: gpointer); cdecl;
var
 userText, passText: PChar;
 EsValido: Boolean;
 userData: TUserData;

begin
    userText := PChar(gtk_entry_get_text(GTK_ENTRY(entryUser)));
    passText := PChar(gtk_entry_get_text(GTK_ENTRY(entryPass)));

    EsValido := LSL_U_ValidateCredentials(userText, passText);

    writeln('Email ingresado: ', userText);
    writeln('Contraseña ingresada: ', passText);

    //Validar las credenciales
    if EsValido then 
    begin
      userData := LSL_U_GetUserByEmail(userText);

      current_user_email := userData.email;
      current_user_name := userData.name;
      current_user_username := userData.username;

      writeln('INICIO-DE-SESIÓN-USUARIO-EXITOSO');

      // Si las credenciales son correctas, cerrar la ventana de login
      gtk_widget_destroy(loginWindow);

      // Mostrar la ventana principal (home)
      MostrarHomeUser;
    end
    else if (userText = root_user_email) and (passText = root_user_password) then
    begin

      current_user_id := 0;
      current_user_name := 'Root';
      current_user_email := root_user_email;
      current_user_username := 'root';

      writeln('INICIO-DE-SESIÓN- ROOT-EXITOSO');

      // Si las credenciales son correctas, cerrar la ventana de login
      gtk_widget_destroy(loginWindow);

      // Mostrar la ventana principal (home)
      MostrarHomeRoot;
    end
    else
    begin
        // Mostrar mensaje de error si las credenciales no son correctas
        writeln('INICIO-DE-SESIÓN-FALLIDO');
        ShowErrorMessage(loginWindow, 'Error de login', 'Usuario o contraseña incorrectas');
    end;
end;

procedure OnCrearClick(widget: PGtkWidget; data: gpointer);cdecl;
begin
  gtk_widget_destroy(loginWindow);
  MostrarCrearWindow;
end;

// Muestra la interfaz de la ventana de login
procedure Mostrarlogin;
var
  grid: PGtkWidget;
  lblUser, lblPass: PGtkWidget;
  btnLogin, btnCrear: PGtkWidget;
begin
  // Inicializar la librería GTK (solo debe hacerse una vez al inicio)
  gtk_init(@argc, @argv);

  // Crear una nueva ventana principal para el login
  loginWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(loginWindow), 'EDDMail');
  gtk_container_set_border_width(GTK_CONTAINER(loginWindow), 10);
  gtk_window_set_default_size(GTK_WINDOW(loginWindow), 300, 200);

  // Crear una tabla para organizar los widgets (etiquetas, entradas y botón)
  grid := gtk_table_new(3, 2, False);
  gtk_container_add(GTK_CONTAINER(loginWindow), grid);

  // Crear etiquetas para los campos
  lblUser := gtk_label_new('Email:');
  lblPass := gtk_label_new('Contraseña:');

  // Crear campos de texto para ingresar usuario y contraseña
  entryUser := gtk_entry_new;
  entryPass := gtk_entry_new;
  gtk_entry_set_visibility(GTK_ENTRY(entryPass), False); // Ocultar caracteres de la contraseña

  // Crear el botón de login y conectar el evento "click"
  btnLogin := gtk_button_new_with_label('Iniciar sesión');
  g_signal_connect(btnLogin, 'clicked', G_CALLBACK(@OnLoginButtonClick), nil);

  // Crear el botón de Crear cuenta y conectar el evento "click"
  btnCrear := gtk_button_new_with_label('Crear Cuenta');
  g_signal_connect(btnCrear, 'clicked', G_CALLBACK(@OnCrearClick), nil);

  // Colocar los elementos en la tabla
  gtk_table_attach_defaults(GTK_TABLE(grid), lblUser, 0, 1, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryUser, 1, 2, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblPass, 0, 1, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryPass, 1, 2, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnLogin, 0, 2, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnCrear, 0, 2, 3, 4); 


  // Mostrar todos los elementos en la ventana
  gtk_widget_show_all(loginWindow);

  // Cuando se cierra la ventana, terminar el programa
  g_signal_connect(loginWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);

  // Iniciar el bucle principal de eventos de GTK
  gtk_main;
end;

end.