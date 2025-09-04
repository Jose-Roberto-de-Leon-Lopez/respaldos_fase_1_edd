unit Agregar_Contacto;

interface

procedure MostrarAgregarWindow;

implementation

uses
  gtk2, glib2, gdk2, homeUser;

var
  insertAgregarWindow: PGtkWidget;
  entryCorreo: PGtkWidget;

procedure OnAddClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  writeln('Agregar Correo');
  writeln('Correo: ', gtk_entry_get_text(GTK_ENTRY(entryCorreo)));

  gtk_widget_destroy(insertAgregarWindow);
  MostrarHomeUser;
end;

procedure OnreturnClick(widget: PGtkWidget; data: gpointer);cdecl;
begin
  gtk_widget_destroy(insertAgregarWindow);
  MostrarHomeUser;
end;

procedure MostrarAgregarWindow;
var
  grid: PGtkWidget;
  lblCorreo, btnAdd, btnReturn: PGtkWidget;
begin
  gtk_init(@argc, @argv);

  insertAgregarWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(insertAgregarWindow), 'Agregar Correo');
  gtk_container_set_border_width(GTK_CONTAINER(insertAgregarWindow), 10);

  grid := gtk_table_new(4, 2, False);
  gtk_container_add(GTK_CONTAINER(insertAgregarWindow), grid);

  lblCorreo := gtk_label_new('Correo:');

  entryCorreo := gtk_entry_new;
 
  btnAdd := gtk_button_new_with_label('Agregar');
  g_signal_connect(btnAdd, 'clicked', G_CALLBACK(@OnAddClick), nil);

  btnReturn := gtk_button_new_with_label('Regresar');
  g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnreturnClick), nil);

  gtk_table_attach_defaults(GTK_TABLE(grid), lblCorreo, 0, 1, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryCorreo, 1, 2, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnAdd, 0, 2, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 2, 2, 3);

  gtk_widget_show_all(insertAgregarWindow);
  g_signal_connect(insertAgregarWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);
  gtk_main;
end;

end.
