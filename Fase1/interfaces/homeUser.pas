unit homeUser;

interface

procedure MostrarHomeUser;

implementation

uses 
    gtk2, glib2, 
    login, Enviar_Correo, Programar_Correo, 
    Agregar_Contacto, Actualizar_Perfil, Bandeja_Entrada,
    doubleLinkedList;
var 
    HomeUserWindow: PGtkWidget;

procedure CloseCurrentWindowAndShowHomeUser(win: PGtkWidget);
begin 
    gtk_widget_destroy(win);
    MostrarHomeUser;
end;

procedure OnBandejaEntradaClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(HomeUserWindow);
  MostrarBandejaWindow;
end;

procedure OnEnviarClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(HomeUserWindow);
  MostrarEnviarWindow;
end;

procedure OnPapeleraClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('VER-PAPELERA');
end;

procedure ONProgramarClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(HomeUserWindow);
  MostrarProgramarWindow;
end;

procedure OnProgramadosClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('VER-CORREOS-PROGRAMADOS');
end;

procedure OnAgregarContactosClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(HomeUserWindow);
  MostrarAgregarWindow;
end;

procedure OnContactosClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('VER-CONTACTOS');
end;

procedure ONPerfilClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(HomeUserWindow);
  MostrarActualizarWindow;
end;

procedure ONReportesClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('GENERANDO-REPORTES');
end;

procedure OnLogoutClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  //LIMPIAR lista doblemente enlazada al cerrar sesión
  LDE_C_Clear();

  gtk_widget_destroy(HomeUserWindow);
  Mostrarlogin;
end;

procedure MostrarHomeUser;
var
  vbox: PGtkWidget;
  btnBandejaEntrada, btnEnviar,btnPapelera,btnProgramar, btnProgramados,btnAgregarContactos, 
  btnContactos, btnPerfil, btnReportes, btnLogout: PGtkWidget;
begin
  // Inicializa GTK 
  gtk_init(@argc, @argv);

  // Crea la ventana principal
  HomeUserWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(HomeUserWindow), 'USUARIO'); // Título de la ventana
  gtk_container_set_border_width(GTK_CONTAINER(HomeUserWindow), 10); // Bordes
  gtk_window_set_default_size(GTK_WINDOW(HomeUserWindow), 300, 600); // Tamaño por defecto

  // Crea un contenedor vertical (VBox) para los botones
  vbox := gtk_vbox_new(True, 5);
  gtk_container_add(GTK_CONTAINER(HomeUserWindow), vbox); // Añade VBox a la ventana

  // Crea los botones con sus respectivas etiquetas
  btnBandejaEntrada := gtk_button_new_with_label('Bandeja de Entrada');
  btnEnviar := gtk_button_new_with_label('Enviar Correo');
  btnPapelera := gtk_button_new_with_label('Papelera');
  btnProgramar := gtk_button_new_with_label('Programar Correo');
  btnProgramados := gtk_button_new_with_label('Correos Programados');
  btnAgregarContactos := gtk_button_new_with_label('Agregar Contactos');
  btnContactos := gtk_button_new_with_label('Contactos');
  btnPerfil := gtk_button_new_with_label('Actualizar Perfil');
  btnReportes := gtk_button_new_with_label('Generar Reportes');
  btnLogout := gtk_button_new_with_label('Cerrar Sesión');

  // Asocia eventos "click" a cada botón 
  g_signal_connect(btnBandejaEntrada, 'clicked', G_CALLBACK(@OnBandejaEntradaClick), nil);
  g_signal_connect(btnEnviar, 'clicked', G_CALLBACK(@OnEnviarClick), nil);
  g_signal_connect(btnPapelera, 'clicked', G_CALLBACK(@OnPapeleraClick), nil);
  g_signal_connect(btnProgramar, 'clicked', G_CALLBACK(@ONProgramarClick), nil);
  g_signal_connect(btnProgramados, 'clicked', G_CALLBACK(@OnProgramadosClick), nil);
  g_signal_connect(btnAgregarContactos, 'clicked', G_CALLBACK(@OnAgregarContactosClick), nil);
  g_signal_connect(btnContactos, 'clicked', G_CALLBACK(@OnContactosClick), nil);
  g_signal_connect(btnPerfil, 'clicked', G_CALLBACK(@ONPerfilClick), nil);
  g_signal_connect(btnReportes, 'clicked', G_CALLBACK(@ONReportesClick), nil);
  g_signal_connect(btnLogout, 'clicked', G_CALLBACK(@OnLogoutClick), nil);

  // Agrega los botones al contenedor vertical
  gtk_box_pack_start(GTK_BOX(vbox), btnBandejaEntrada, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnEnviar, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnPapelera, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnProgramar, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnProgramados, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnAgregarContactos, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnContactos, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnPerfil, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnReportes, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnLogout, False, False, 0);


  // Muestra todos los elementos en la ventana
  gtk_widget_show_all(HomeUserWindow);

  // Cierra la aplicación cuando se destruye la ventana
  g_signal_connect(HomeUserWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);

  // Inicia el bucle principal de eventos de GTK
  gtk_main;
end;

end.
