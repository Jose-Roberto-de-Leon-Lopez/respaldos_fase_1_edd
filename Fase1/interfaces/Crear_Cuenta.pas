unit Crear_Cuenta;

interface

procedure MostrarCrearWindow;

implementation

uses
  gtk2, glib2, gdk2, 
  login, interfaceTools, jsonTools, simpleLinkedList, 
  variables, SysUtils;

var
  insertCrearWindow: PGtkWidget;
  entryID, entryName, entryUser, entrypassword, entryEmail, entryPhone: PGtkWidget;

procedure OnCreateClick(widget: PGtkWidget; data: gpointer); cdecl;
var
  value_entryId, value_entryName, value_entryUser, value_entryPassword, value_entryEmail, value_entryPhone : PChar;
  statusUploadJson : Boolean;
begin
  writeln('Crear correo');
  writeln('ID: ', gtk_entry_get_text(GTK_ENTRY(entryID)));
  writeln('Nombre: ', gtk_entry_get_text(GTK_ENTRY(entryName)));
  writeln('Usuario: ', gtk_entry_get_text(GTK_ENTRY(entryUser)));
  writeln('Password: ', gtk_entry_get_text(GTK_ENTRY(entrypassword)));
  writeln('Email: ', gtk_entry_get_text(GTK_ENTRY(entryEmail)));
  writeln('Telefono: ', gtk_entry_get_text(GTK_ENTRY(entryPhone)));

  //obtener valores
  value_entryId := PChar(gtk_entry_get_text(GTK_ENTRY(entryID)));
  value_entryName := Pchar(gtk_entry_get_text(GTK_ENTRY(entryName)));
  value_entryUser := Pchar(gtk_entry_get_text(GTK_ENTRY(entryUser)));
  value_entryPassword := Pchar(gtk_entry_get_text(GTK_ENTRY(entrypassword)));
  value_entryEmail := Pchar(gtk_entry_get_text(GTK_ENTRY(entryEmail)));
  value_entryPhone := pchar(gtk_entry_get_text(GTK_ENTRY(entryPhone)));

  //insertar Usuario a la lista 
  LSL_U_Insert(value_entryId, value_entryName, value_entryUser, value_entryPassword, value_entryEmail, value_entryPhone);
  statusUploadJson := AddUserToJson(json_file_prueva, StrToInt(value_entryId), value_entryName, value_entryUser, value_entryPassword, value_entryEmail, value_entryPhone);
  
  if not statusUploadJson then
  begin
  ShowErrorMessage(insertCrearWindow, 'Error Carga en Archivo Json','No se pudo registrar el usuario.');
  exit;
  end;

  ShowSuccessMessage(insertCrearWindow,'Registro Exitoso','El usuario ha sido registrado correctamente.');
         
  gtk_widget_destroy(insertCrearWindow);
  Mostrarlogin;
end;

procedure OnreturnClick(widget: PGtkWidget; data: gpointer);cdecl;
begin
  gtk_widget_destroy(insertCrearWindow);
  Mostrarlogin;
end;

procedure MostrarCrearWindow;
var
  grid: PGtkWidget;
  lblID, lblName, lblUser, lblPassword, lblEmail, lblPhone, btnCreate, btnReturn: PGtkWidget;
begin
  gtk_init(@argc, @argv);

  insertCrearWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(insertCrearWindow), 'Crear Correo');
  gtk_container_set_border_width(GTK_CONTAINER(insertCrearWindow), 10);

  grid := gtk_table_new(8, 2, False);
  gtk_container_add(GTK_CONTAINER(insertCrearWindow), grid);

  lblID := gtk_label_new('ID:');
  lblName := gtk_label_new('Nombre:');
  lblUser := gtk_label_new('Usuario:');
  lblPassword := gtk_label_new('Password');
  lblEmail := gtk_label_new('Email:');
  lblPhone := gtk_label_new('Telefono');

  entryID := gtk_entry_new;
  entryName := gtk_entry_new;
  entryUser := gtk_entry_new;
  entrypassword := gtk_entry_new;
  entryEmail := gtk_entry_new;
  entryPhone := gtk_entry_new;

  btnCreate := gtk_button_new_with_label('Crear Cuenta');
  g_signal_connect(btnCreate, 'clicked', G_CALLBACK(@OnCreateClick), nil);

  btnReturn := gtk_button_new_with_label('Regresar');
  g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnreturnClick), nil);

  gtk_table_attach_defaults(GTK_TABLE(grid), lblID, 0, 1, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryID, 1, 2, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblName, 0, 1, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryName, 1, 2, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblUser, 0, 1, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryUser, 1, 2, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblPassword, 0, 1, 3, 4);
  gtk_table_attach_defaults(GTK_TABLE(grid), entrypassword, 1, 2, 3, 4);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblEmail, 0, 1, 4, 5);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryEmail, 1, 2, 4, 5);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblPhone, 0, 1, 5, 6);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryPhone, 1, 2, 5, 6);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnCreate, 0, 2, 6, 7);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 2, 7, 8);

  gtk_widget_show_all(insertCrearWindow);
  g_signal_connect(insertCrearWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);
  gtk_main;
end;

end.
