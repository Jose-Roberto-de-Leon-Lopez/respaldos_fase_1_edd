unit Programar_Correo;

interface

procedure MostrarProgramarWindow;

implementation

uses
  gtk2, glib2, gdk2, homeUser;

var
  insertProgramarWindow: PGtkWidget;
  entryDestinatario, entryAsunto, entryMensaje, entryFecha: PGtkWidget;

procedure OnProgramClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  writeln('Programar correo');
  writeln('Destonatario: ', gtk_entry_get_text(GTK_ENTRY(entryDestinatario)));
  writeln('Asunto: ', gtk_entry_get_text(GTK_ENTRY(entryAsunto)));
  writeln('Mensaje: ', gtk_entry_get_text(GTK_ENTRY(entryMensaje)));
  writeln('Fecha: ', gtk_entry_get_text(GTK_ENTRY(entryFecha)));

  gtk_widget_destroy(insertProgramarWindow);
  MostrarHomeUser;
end;

procedure OnreturnClick(widget: PGtkWidget; data: gpointer);cdecl;
begin
  gtk_widget_destroy(insertProgramarWindow);
  MostrarHomeUser;
end;

procedure MostrarProgramarWindow;
var
  grid: PGtkWidget;
  lblDestin, lblAs, lblMSN, lblDate, btnProgram, btnReturn: PGtkWidget;
begin
  gtk_init(@argc, @argv);

  insertProgramarWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(insertProgramarWindow), 'Programar Correo');
  gtk_container_set_border_width(GTK_CONTAINER(insertProgramarWindow), 10);

  grid := gtk_table_new(6, 2, False);
  gtk_container_add(GTK_CONTAINER(insertProgramarWindow), grid);

  lblDestin := gtk_label_new('Destinatario:');
  lblAs := gtk_label_new('Asunto:');
  lblMSN := gtk_label_new('Mensaje:');
  lblDate := gtk_label_new('Fecha');

  entryDestinatario := gtk_entry_new;
  entryAsunto := gtk_entry_new;
  entryMensaje := gtk_entry_new;
  entryFecha := gtk_entry_new;

  btnProgram := gtk_button_new_with_label('Programar');
  g_signal_connect(btnProgram, 'clicked', G_CALLBACK(@OnProgramClick), nil);

  btnReturn := gtk_button_new_with_label('Regresar');
  g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnreturnClick), nil);

  gtk_table_attach_defaults(GTK_TABLE(grid), lblDestin, 0, 1, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryDestinatario, 1, 2, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblAs, 0, 1, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryAsunto, 1, 2, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblMSN, 0, 1, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryMensaje, 1, 2, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblDate, 0, 1, 3, 4);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryFecha, 1, 2, 3, 4);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnProgram, 0, 2, 4, 5);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 2, 5, 6);

  gtk_widget_show_all(insertProgramarWindow);
  g_signal_connect(insertProgramarWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);
  gtk_main;
end;

end.
