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

module WritePng(P : ImageOps) : WritePng 

module RgbImage : ImageOps
module RgbToPng : WritePng with type image = RgbImage.image

