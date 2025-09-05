unit Enviar_Correo;

interface

procedure MostrarEnviarWindow;

implementation

uses
  gtk2, glib2, gdk2, SysUtils,
  homeUser, variables, jsonTools, doubleLinkedList;

var
  insertEnviarWindow: PGtkWidget;
  entryDestinatario, entryAsunto, entryMensaje: PGtkWidget;

procedure OnSendClick(widget: PGtkWidget; data: gpointer); cdecl;
var
  destinatario, asunto, mensaje: PChar;
  fecha: string;
  success: Boolean;
begin
  // Obtener valores de los campos
  destinatario := PChar(gtk_entry_get_text(GTK_ENTRY(entryDestinatario)));
  asunto := PChar(gtk_entry_get_text(GTK_ENTRY(entryAsunto)));
  mensaje := PChar(gtk_entry_get_text(GTK_ENTRY(entryMensaje)));

  writeln('ENVIANDO-CORREO');
  writeln('Destinatario: ', destinatario);
  writeln('Asunto: ', asunto);
  writeln('Mensaje: ', mensaje);

  // Validar campos obligatorios
  if (Trim(destinatario) = '') or (Trim(asunto) = '') or (Trim(mensaje) = '') then
  begin
    writeln('ERROR: Todos los campos son obligatorios');
    Exit;
  end;

  // Generar fecha actual
  fecha := FormatDateTime('yyyy-mm-dd hh:nn', Now);

  // Guardar correo en JSON usando la variable existente
  success := jsonTools.SaveEmailToJson(
    variables.json_file_email,
    '',                         // ID vacío
    variables.current_user_email,  // remitente
    destinatario,                  // destinatario (ya estaba bien)
    'NL',                          // estado: no leído
    False,                         // no programado
    asunto,
    fecha,
    mensaje
);


  if success then
  begin
    writeln('CORREO-ENVIADO-EXITOSAMENTE');
  end
  else
  begin
    writeln('ERROR-AL-GUARDAR-CORREO');
  end;

  gtk_widget_destroy(insertEnviarWindow);
  MostrarHomeUser;
end;

procedure OnreturnClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_widget_destroy(insertEnviarWindow);
  MostrarHomeUser;
end;

procedure MostrarEnviarWindow;
var
  grid: PGtkWidget;
  lblDestin, lblAs, lblMSN, btnSend, btnReturn: PGtkWidget;
begin
  gtk_init(@argc, @argv);

  insertEnviarWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(insertEnviarWindow), 'Enviar Mensaje');
  gtk_container_set_border_width(GTK_CONTAINER(insertEnviarWindow), 10);

  grid := gtk_table_new(6, 2, False);
  gtk_container_add(GTK_CONTAINER(insertEnviarWindow), grid);

  lblDestin := gtk_label_new('Destinatario:');
  lblAs := gtk_label_new('Asunto:');
  lblMSN := gtk_label_new('Mensaje:');

  entryDestinatario := gtk_entry_new;
  entryAsunto := gtk_entry_new;
  entryMensaje := gtk_entry_new;

  btnSend := gtk_button_new_with_label('Enviar');
  g_signal_connect(btnSend, 'clicked', G_CALLBACK(@OnSendClick), nil);

  btnReturn := gtk_button_new_with_label('Regresar');
  g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnreturnClick), nil);

  gtk_table_attach_defaults(GTK_TABLE(grid), lblDestin, 0, 1, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryDestinatario, 1, 2, 0, 1);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblAs, 0, 1, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryAsunto, 1, 2, 1, 2);
  gtk_table_attach_defaults(GTK_TABLE(grid), lblMSN, 0, 1, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), entryMensaje, 1, 2, 2, 3);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnSend, 0, 2, 4, 5);
  gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 2, 5, 6);

  gtk_widget_show_all(insertEnviarWindow);
  g_signal_connect(insertEnviarWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);
  gtk_main;
end;

end.