open Gc

let html gc = 
    let total = gc.major_words +. gc.minor_words -. gc.promoted_words in
    let rect percent = 
        let width = string_of_int (int_of_float (3. *. percent)) in
        <:html<
            <svg width="300" height="20">
                <rect width=$str:width$ height="20" style="fill:gray"></rect>
            </svg>
        >>
    in
    let row name value total = 
        <:html<
                <tr style="border:0px"> 
                <td style="border:0px;text-align:right">$str:name$</td> 
                <td style="border:0px;text-align:center">$flo:value$</td>
                <td style="border:0px;">$rect (100. *. value /. total)$</td>
            </tr>
        >>
    in
    <:html<
        <table style="border:4px solid">
            <tr><td colspan="3" style="text-align:center">Words since start</td></tr>
            $row "total" total total$
            $row "minor" gc.minor_words total$
            $row "major" gc.major_words total$
            $row "promoted" gc.promoted_words total$
            <tr><td colspan="3" style="text-align:center">Live words</td></tr>
            $row "max" (float gc.top_heap_words) (float gc.top_heap_words)$
            $row "total" (float gc.heap_words) (float gc.top_heap_words)$
            $row "live" (float gc.live_words) (float gc.top_heap_words)$
            $row "free" (float gc.free_words) (float gc.top_heap_words)$
        </table>
    >>

let write f gc = 
    output_string f (Cow.Xml.to_string (html gc))

let display gc = write Iocaml.mime gc; Iocaml.send_mime "text/html"

let printer fmt gc = display gc; Format.fprintf fmt "<gc>"

