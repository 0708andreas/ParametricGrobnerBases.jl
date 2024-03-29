module ParametricGrobnerBases

using MultivariatePolynomials
MP = MultivariatePolynomials
using DynamicPolynomials
using DataStructures
using GLMakie
import Contour
import Base.div
import Base.show

__show_poly_types = false

@polyvar x y u v

# include("Weispfenning.jl")

include("SSAlgo.jl")

export CGSMain, CGS, CGBMain, CGB

function make_parameters(p, vars)
    p_ = polynomial(zero(p), polynomial_type(leading_coefficient(p)*prod(vars)))
    for t in terms(p)
        mon = monomial(subs(t, [var => 1 for var in vars]...))

        remaining_vars = filter(x -> !(x in vars), variables(monomial(t)))
        if isempty(remaining_vars)
            coef = t
        else
            coef = subs(t, [var => 1 for var in remaining_vars]...)
        end

        p_ = p_ + term(coef, mon)
    end
    return p_
end

unparameterize(t) = coefficient(t) * monomial(t)


function plot_poly(p, params)
    f = Figure()
    ax = Axis(f[1, 1])
    sliders = []
    p_ = subs(p, (par => 5 for par in params)...)
    # for (i, par) in enumerate(params)
    #     sl = Slider(f[1, i+1], range=-10:0.01:10, startvalue=5)
    #     on(sl.value) do _
    #         p_[] = subs(p, (par => slider.value[] for (par, slider) in zip(params, sliders))...)
    #     end

    #     push!(sliders, Slider(f[1, i+1], range=-10:0.01:10, startvalue=5))
    # end

    r = -10:0.1:10
    z = [p_(x => xi, y => yi) for xi in r, yi in r]
    lns = Contour.lines(Contour.contour(collect(r), collect(r), z, 0.0))
    empty!(ax)
    for ln in lns
        xs, ys = Contour.coordinates(ln)
        lines!(ax, xs, ys)
    end
    return f
end


export x, y, u, v, make_parameters, Color, green, red, white, Condition, color,
    leading_term, extend_cover, DET, is_reducible, NORMALFORM, SPol, GROBNERSYSTEM

end
