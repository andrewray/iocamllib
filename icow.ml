module Xml = struct
    let write f xml = output_string f (Cow.Xml.to_string xml)
    let display xml = write Iocaml.mime xml; Iocaml.send_mime "text/html"
    let printer fmt xml = display xml; Format.fprintf fmt "<cow>"
end

module Css = struct
    let write f css = 
        output_string f "<style>\n";
        output_string f (Cow.Css.to_string css);
        output_string f "</style>\n"
    let display css = write Iocaml.mime css; Iocaml.send_mime "text/html"
    let printer fmt css = display css; Format.fprintf fmt "<css>"
end

