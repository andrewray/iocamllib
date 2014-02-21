module type ImageOps = sig
    type pixel
    type image

    val create : width:int -> height:int -> image
    val init : width:int -> height:int -> f:(int -> int -> pixel) -> image

    val width : image -> int
    val height : image -> int

    val pixel : r:int -> g:int -> b:int -> pixel
    val pixela : r:int -> g:int -> b:int -> a:int -> pixel

    val get : image -> x:int -> y:int -> pixel
    val set : image -> x:int -> y:int -> pixel -> unit

    val r : pixel -> int
    val g : pixel -> int
    val b : pixel -> int
    val a : pixel -> int

end

module type WritePng = sig
    type image
    val write : out_channel -> image -> unit
    val display : image -> unit
    val printer : Format.formatter -> image -> unit
end

module WritePng(P : ImageOps) : (WritePng with type image = P.image) = struct

    type image = P.image

    module I32 = Int32

    let (>>) = I32.shift_right_logical
    let (&) = I32.logand
    let (^) = I32.logxor

    let crc_table =
      let crc i =
        let t = ref (I32.of_int i) in
        for j = 0 to 7 do
          t := (!t >> 1) ^ (0xedb88320l & (I32.succ (I32.lognot (!t & 1l))))
        done;
        !t in
      let tbl = Array.init 256 crc in
      tbl
        
    let acc_crc crc v =
      crc_table.(I32.to_int ((crc ^ (I32.of_int v)) & 0xffl)) ^ (crc >> 8)

    let acc_adler (a1,a2) v =
      let a1' = (a1 + v) mod 65521 in
      (a1', ((a2 + a1') mod 65521))

    let write_dword chnl i =
      let output_byte_i32 i = 
        output_byte chnl (I32.to_int i) in
      output_byte_i32 (i >> 24);
      output_byte_i32 (i >> 16);
      output_byte_i32 (i >> 8);
      output_byte_i32 i

    let write chnl image =
      let h = P.height image in
      let w = P.width image in
      let bpp = 4 in
      let idatlen = 6 + h * (6 + w * bpp) in
      output_string chnl "\x89PNG\x0d\x0a\x1a\x0a\x00\x00\x00\x0dIHDR";
      let hdr = 
        [0; w lsr 16; w lsr 8; w;
         0; h lsr 16; h lsr 8; h;
         8; 6; 0; 0; 0] in

      let output_crc_byte crc v =
        let b = v land 255 in
        output_byte chnl b;
        acc_crc crc b in

      let output_adler_byte (crc,a1,a2) v =
        let b = v land 255 in
        output_byte chnl b;
        let (a1,a2) = acc_adler (a1,a2) b in
        (acc_crc crc v,a1,a2) in

      let write_crc_bytes acc lst = 
        List.fold_left output_crc_byte acc lst in

      let crc = write_crc_bytes 0x575e51f5l hdr in
      write_dword chnl (I32.lognot crc);
      write_dword chnl (I32.of_int idatlen);
      output_string chnl "IDAT\x78\x01";

      let rec write_rows ((crc,adler1,adler2) as acc) y =
        if y < h then
          let blocklen = w * bpp + 1 in
          let bytes = [(if (y = h-1) then 1 else 0);
                       blocklen; blocklen lsr 8;
                       lnot blocklen; (lnot blocklen) lsr 8] in

          let rec output_row x acc =
            if x < w then
              let pix = P.get image ~x ~y in
              let pix_bytes = [
                  P.r pix;
                  P.g pix;
                  P.b pix;
                  P.a pix;
            ] in
              output_row (x+1) 
                (List.fold_left output_adler_byte acc pix_bytes)
            else
              acc in

          let crc = write_crc_bytes crc bytes in
          let adler = 
            output_adler_byte (crc,adler1,adler2) 0 in
          write_rows (output_row 0 adler) (y+1)
        else 
          acc in
      
      let (crc,adler1,adler2) = 
        write_rows (0x13e5812dl,1,0) 0 in

      let bytes = [adler2 lsr 8; adler2; adler1 lsr 8; adler1] in
      let crc = write_crc_bytes crc bytes in
      write_dword chnl (I32.lognot crc);
      output_string chnl "\x00\x00\x00\x00IEND\xae\x42\x60\x82"

    let display image = 
        write Iocaml.mime image;
        Iocaml.send_mime ~base64:true "image/png"

    let printer fmt image = display image; Format.fprintf fmt "<png>"

end

module RgbImage = struct

    type pixel = 
        {
            r : char;
            g : char;
            b : char;
            a : char;
        }

    type image = pixel array array

    let pixel ~r ~g ~b = 
        {
            r = char_of_int r;
            g = char_of_int g;
            b = char_of_int b;
            a = char_of_int 255;
        }


    let pixela ~r ~g ~b ~a = 
        {
            r = char_of_int r;
            g = char_of_int g;
            b = char_of_int b;
            a = char_of_int a;
        }

    let create ~width ~height = 
        Array.init height (fun _ -> Array.create width (pixel 0 0 0))

    let init ~width ~height ~f = 
        Array.init height (fun y -> Array.init width (fun x -> f x y))

    let height image = Array.length image
    let width image = Array.length image.(0)

    let get image ~x ~y = image.(y).(x)
    let set image ~x ~y p = image.(y).(x) <- p

    let r p = int_of_char p.r
    let g p = int_of_char p.g
    let b p = int_of_char p.b
    let a p = int_of_char p.a

end 

module RgbToPng = 
    (WritePng(RgbImage) : WritePng with type image = RgbImage.image)


