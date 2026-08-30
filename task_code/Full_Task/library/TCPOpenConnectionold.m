function success = TCPOpenConnection()


    global d_output_stream
    global server_socket
    global output_socket
    
    import java.net.ServerSocket
    import java.io.*
     
    output_port = 8154;
    number_of_retries = 12; % set to -1 for infinite

    retry             = 0;
    success = false;

    server_socket  = [];
    output_socket  = [];

    while true

        retry = retry + 1;

        try
            if ((number_of_retries > 0) && (retry > number_of_retries))
                fprintf(1, 'Reached limit of retries to connect (%d).\n',retry);
                break;
            end

            fprintf(1, ['Try %d waiting for Getty to connect to this ' ...
                        'host on port : %d\n'], retry, output_port);

            % wait for 1 second for client to connect server socket
            server_socket = ServerSocket(output_port);
            TimeOutSecs = 10; %Time to wait in seconds each retry.
            TimeOut = TimeOutSecs*1000;
            server_socket.setSoTimeout(TimeOut);

            output_socket = server_socket.accept;

            success = true;
            fprintf(1, 'Getty connected\n');

            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);

            break
            
        catch
            if ~isempty(server_socket)
                server_socket.close
            end

            if ~isempty(output_socket)
                output_socket.close
            end

            m = lasterror;
            m.message
            pause(0.5);
            if press==1
                break
            end
        end
    end
end