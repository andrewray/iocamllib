module Xml : sig
    val write : out_channel -> Cow.Xml.t -> unit
    val display : Cow.Xml.t -> unit
    val printer : Format.formatter -> Cow.Xml.t -> unit
end

module Css : sig
    val write : out_channel -> Cow.Css.t -> unit
    val display : Cow.Css.t -> unit
    val printer : Format.formatter -> Cow.Css.t -> unit
end

