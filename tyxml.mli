module Html : sig
    val write : out_channel -> 'a Html5.M.elt list -> unit
    val display : 'a Html5.M.elt list -> unit
    val printer : Format.formatter -> 'a Html5.M.elt list -> unit
end

module Svg : sig
    val write : out_channel -> 'a Svg.M.elt list -> unit
    val display : 'a Svg.M.elt list -> unit
    val printer : Format.formatter -> 'a Svg.M.elt list -> unit
end

