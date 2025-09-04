unit homeRoot;

interface

procedure MostrarHomeRoot;

implementation

uses 
    gtk2, glib2, login, interfaceTools, jsonTools, 
    variables, filesTools, simpleLinkedList;
var 
    HomeRootWindow: PGtkWidget;
    btnCargaMasiva, btnRepUser, btnRepRel, btnComunidad, btnLogout: PGtkWidget;


procedure CloseCurrentWindowAndShowHomeRoot(win: PGtkWidget);
begin 
    gtk_widget_destroy(win);
    MostrarHomeRoot;
end;

procedure OnCargaMasivaClick(widget: PGtkWidget; data: gpointer); cdecl;
  var
    status: Boolean;
  begin
  status := jsonTools.UploadUsersFromJson(json_file_prueva);
  Writeln('REALIZANDO-CARGA-MASIVA');
  if status then 
  begin
    ShowSuccessMessage(HomeRootWindow, 'Carga de archivo JSON', 'Los usuarios han sioo cargados con exito');
  end
  else
    ShowErrorMessage(HomeRootWindow,'Carga de archivo JSON', 'A ocurrido un error, verificar el archivo JSON');
end;

procedure OnRepUserClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('REPORTES-DE-USUARIO-GENERADOS');
  filesTools.GenerateReports('user', 'Root Report',  LSL_U_GenerateDot());
end;

procedure OnRepRelClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('REPORTES-DE-RELACIONES-GENERADOS');
end;

procedure ONComunidadClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  Writeln('COMUNIDAD-CREADA');
end;

procedure OnLogoutClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(HomeRootWindow);
  Mostrarlogin;
end;

procedure MostrarHomeRoot;
var
  vbox: PGtkWidget;
  btnCargaMasiva, btnRepUser, btnRepRel, btnComunidad, btnLogout: PGtkWidget;
begin
  // Inicializa GTK 
  gtk_init(@argc, @argv);

  // Crea la ventana principal
  HomeRootWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(HomeRootWindow), 'ROOT'); // Título de la ventana
  gtk_container_set_border_width(GTK_CONTAINER(HomeRootWindow), 10); // Bordes
  gtk_window_set_default_size(GTK_WINDOW(HomeRootWindow), 300, 300); // Tamaño por defecto

  // Crea un contenedor vertical (VBox) para los botones
  vbox := gtk_vbox_new(True, 5);
  gtk_container_add(GTK_CONTAINER(HomeRootWindow), vbox); // Añade VBox a la ventana

  // Crea los botones con sus respectivas etiquetas
  btnCargaMasiva := gtk_button_new_with_label('Carga Masiva');
  btnRepUser := gtk_button_new_with_label('Reporte de Usiarios');
  btnRepRel := gtk_button_new_with_label('Reporte de Relaciones');
  btnComunidad := gtk_button_new_with_label('Crear Comunidades');
  btnLogout := gtk_button_new_with_label('Cerrar Sesión');

  // Asocia eventos "click" a cada botón 
  g_signal_connect(btnCargaMasiva, 'clicked', G_CALLBACK(@OnCargaMasivaClick), nil);
  g_signal_connect(btnRepUser, 'clicked', G_CALLBACK(@OnRepUserClick), nil);
  g_signal_connect(btnRepRel, 'clicked', G_CALLBACK(@OnRepRelClick), nil);
  g_signal_connect(btnComunidad, 'clicked', G_CALLBACK(@ONComunidadClick), nil);
  g_signal_connect(btnLogout, 'clicked', G_CALLBACK(@OnLogoutClick), nil);

  // Agrega los botones al contenedor vertical
  gtk_box_pack_start(GTK_BOX(vbox), btnCargaMasiva, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnRepUser, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnRepRel, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnComunidad, False, False, 0);
  gtk_box_pack_start(GTK_BOX(vbox), btnLogout, False, False, 0);

  // Muestra todos los elementos en la ventana
  gtk_widget_show_all(HomeRootWindow);

  // Cierra la aplicación cuando se destruye la ventana
  g_signal_connect(HomeRootWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);

  // Inicia el bucle principal de eventos de GTK
  gtk_main;
end;

end.
