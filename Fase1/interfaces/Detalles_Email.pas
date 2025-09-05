unit Detalles_Email;

interface

procedure MostrarDetailsWindow(emailId: string);

implementation

uses
    gtk2, glib2, gdk2,
    doubleLinkedList, variables,
    Bandeja_Entrada;  // ← Unit cambiada

var
    detailsWindow: PGtkWidget;

procedure OnReturnClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
    gtk_widget_destroy(detailsWindow);
    Bandeja_Entrada.MostrarBandejaWindow;  // ← Unit cambiada
end;

procedure MostrarDetailsWindow(emailId: string);
var
    grid: PGtkWidget;
    email: TEmailData;
    lblRemitente, lblAsunto, lblFecha, lblEstado, lblMensaje: PGtkWidget;
    btnReturn: PGtkWidget;
begin
    gtk_init(@argc, @argv);

    // Obtener datos del correo
    email := doubleLinkedList.LDE_C_GetEmailById(emailId);

    // Marcar como leído al abrir
    if email.estado = 'NL' then
        doubleLinkedList.LDE_C_MarkAsRead(emailId);

    // Crear ventana
    detailsWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(detailsWindow), 'Detalles del Correo');
    gtk_container_set_border_width(GTK_CONTAINER(detailsWindow), 10);
    gtk_window_set_default_size(GTK_WINDOW(detailsWindow), 500, 400);

    // Crear tabla para organizar
    grid := gtk_table_new(7, 2, False);
    gtk_container_add(GTK_CONTAINER(detailsWindow), grid);

    // Remitente
    gtk_table_attach_defaults(GTK_TABLE(grid), gtk_label_new('Remitente:'), 0, 1, 0, 1);
    lblRemitente := gtk_label_new(PChar(email.remitente));
    gtk_table_attach_defaults(GTK_TABLE(grid), lblRemitente, 1, 2, 0, 1);

    // Asunto
    gtk_table_attach_defaults(GTK_TABLE(grid), gtk_label_new('Asunto:'), 0, 1, 1, 2);
    lblAsunto := gtk_label_new(PChar(email.asunto));
    gtk_table_attach_defaults(GTK_TABLE(grid), lblAsunto, 1, 2, 1, 2);

    // Fecha
    gtk_table_attach_defaults(GTK_TABLE(grid), gtk_label_new('Fecha:'), 0, 1, 2, 3);
    lblFecha := gtk_label_new(PChar(email.fecha));
    gtk_table_attach_defaults(GTK_TABLE(grid), lblFecha, 1, 2, 2, 3);

    // Estado
    gtk_table_attach_defaults(GTK_TABLE(grid), gtk_label_new('Estado:'), 0, 1, 3, 4);
    if email.estado = 'NL' then
        lblEstado := gtk_label_new('NO LEÍDO')
    else
        lblEstado := gtk_label_new('LEÍDO');
    gtk_table_attach_defaults(GTK_TABLE(grid), lblEstado, 1, 2, 3, 4);

    // Mensaje (con más espacio)
    gtk_table_attach_defaults(GTK_TABLE(grid), gtk_label_new('Mensaje:'), 0, 1, 4, 5);
    lblMensaje := gtk_label_new(PChar(email.mensaje));
    gtk_table_attach_defaults(GTK_TABLE(grid), lblMensaje, 0, 2, 5, 6);

    // Botón Regresar
    btnReturn := gtk_button_new_with_label('Regresar');
    g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnReturnClick), nil);
    gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 2, 6, 7);

    // Mostrar todo
    gtk_widget_show_all(detailsWindow);

    // Evento de cerrar
    g_signal_connect(detailsWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);

    // Iniciar bucle GTK
    gtk_main;
end;

end.