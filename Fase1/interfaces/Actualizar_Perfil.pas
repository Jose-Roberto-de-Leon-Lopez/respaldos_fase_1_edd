unit Actualizar_Perfil;

interface

procedure MostrarActualizarWindow;

implementation

uses
  gtk2, glib2, gdk2, homeUser;

var
  insertActuaizarWindow: PGtkWidget;
  entryName, entryUser, entryCorreo, entryPhone: PGtkWidget;

procedure OnUpdateClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  writeln('Actualizar');
  writeln('Nombre: ', gtk_entry_get_text(GTK_ENTRY(entryName)));
  writeln('Usuario: ', gtk_entry_get_text(GTK_ENTRY(entryUser)));
  writeln('Correo: ', gtk_entry_get_text(GTK_ENTRY(entryCorreo)));
  writeln('Telefono: ', gtk_entry_get_text(GTK_ENTRY(entryPhone)));

  gtk_widget_destroy(insertActuaizarWindow);
  MostrarHomeUser;
end;

procedure OnreturnClick(widget: PGtkWidget; data: gpointer);cdecl;
begin
  gtk_widget_destroy(insertActuaizarWindow);
  MostrarHomeUser;
end;

procedure MostrarActualizarWindow;
var
  grid: PGtkWidget;
  lblName, lblUser, lblCorreo, lblPhone, btnUpdate, btnReturn: PGtkWidget;
begin
  gtk_init(@argc, @argv);

  insertActuaizarWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(insertActuaizarWindow), 'Actualizar Perfil');
  gtk_container_set_border_width(GTK_CONTAINER(insertActuaizarWindow), 10);

  grid := gtk_table_new(6, 2, False);
  gtk_container_add(GTK_CONTAINER(insertActuaizarWindow), grid);

  lblName := gtk_label_new('Nombre:');
  lblUser := gtk_label_new('Usuario:');
  lblCorreo := gtk_label_new('Correo:');
  lblPhone := gtk_label_new('Telefono');

  entryName := gtk_entry_new;
  entryUser := gtk_entry_new;
  entryCorreo := gtk_entry_new;
  entryPhone := gtk_entry_new;

  btnUpdate := gtk_button_new_with_label('Actualizar Perfil');
  g_signal_connect(btnUpdate, 'clicked', G_CALLBACK(@OnUpdateClick), nil);

  btnReturn := gtk_button_new_with_label('Regresar');
  g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnreturnClick), nil);

  gtk_table_attach_defaults(GTK_TABLE(grid), lblName, 0, 1, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryName, 1, 2, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblUser, 0, 1, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryUser, 1, 2, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblCorreo, 0, 1, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryCorreo, 1, 2, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblPhone, 0, 1, 3, 4);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryPhone, 1, 2, 3, 4);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnUpdate, 0, 2, 4, 5);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 2, 5, 6);

  gtk_widget_show_all(insertActuaizarWindow);
  g_signal_connect(insertActuaizarWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);
  gtk_main;
end;

end.
