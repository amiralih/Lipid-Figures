using Luxor, Random

"""
Draw a lipid tail.
"""
function draw_lipid_tail(rseed=123, t=0)
    Random.seed!(rseed)
    ϕ = rand() * 2π
    xs = range(0, 199, step=1)
    ys = 10sin.((π/50) * xs .+ ϕ .+ (2π * t))

    for i in 1:199
        line(Point(xs[i], ys[i]), Point(xs[i+1], ys[i+1]), :path)
    end
    
    setlinecap(:round)
    sethue("black")
    setline(9)
    strokepreserve()
    sethue("gold")
    setline(6)
    strokepath()
end

"""
Draws a lipid.
"""
function draw_lipid(rseed=123, t=0)    
    @layer begin
        translate(0, 25)
        draw_lipid_tail(rseed, t)
    end
    @layer begin
        translate(0, -25)
        draw_lipid_tail(rseed+1, t)
    end
    @layer begin
        translate(199, 0)
        circle(O, 50, :path)
        sethue("steelblue3")
        fillpreserve()
        sethue("black")
        setline(3)
        strokepath()
    end
end

"""
Draws a bilayer.
"""
function draw_bilayer(rseed=123, t=0)
    for i in 0:30
        @layer begin
            translate((i-15)*40, 7)
            rotate(π/2)
            scale(1/3)
            draw_lipid(i, t)
        end
        @layer begin
            translate((i-15)*40, -7)
            rotate(-π/2)
            scale(1/3)
            draw_lipid(i+30, t)
        end
    end
end

"""
Draws a curved bilayer.
"""
function draw_curved_bilayer(rseed=123, t=0)
    Random.seed!(rseed)
    ϕ = rand() * 2π
    xs = ((0:30) .- 15) .* 40
    ys = 10 * sin.((3π/(last(xs) - first(xs))) * xs .+ ϕ .+ (2π * t))
    θs = (π/16) * sin.((3π/(last(xs) - first(xs))) * xs .+ ϕ .+ (2π * t) .- (π/2))
    for i in 1:31
        @layer begin
            translate(xs[i], ys[i]+7)
            rotate(π/2 - θs[i])
            scale(1/3)
            draw_lipid(i, t)
        end
        @layer begin
            translate(xs[i], ys[i]-7)
            rotate(-π/2 - θs[i])
            scale(1/3)
            draw_lipid(i+30, t)
        end
    end
end

@pdf begin
    origin()
    draw_curved_bilayer()
end 1500 400 "test_curved_bilayer.pdf"

curvedbilayermovie = Movie(1400, 300, "Curved Bilayer Movie")
function frame(scene::Scene, framenumber::Int64)
    background("white")
    norm_framenumber = rescale(framenumber,
        scene.framerange.start,
        scene.framerange.stop,
        0, 1)
    origin()
    draw_curved_bilayer(123, norm_framenumber)
end
animate(curvedbilayermovie,
    [Scene(curvedbilayermovie, frame, 1:120)],
    creategif=true,
    pathname="curvedbilayermovie.gif")

#=
@pdf begin
    origin()
    draw_bilayer()
end 1500 400 "test_bilayer.pdf"


@pdf begin
    origin()
    rotate(-π/2)
    translate(-100, 0)
    draw_lipid()
end 400 400 "test_lipid.pdf"

lipidmovie = Movie(400, 400, "Lipid Movie")
function frame(scene::Scene, framenumber::Int64)
    background("white")
    norm_framenumber = rescale(framenumber,
        scene.framerange.start,
        scene.framerange.stop,
        0, 1)
    origin()
    rotate(-π/2)
    translate(-100, 0)
    draw_lipid(123, norm_framenumber)
end
animate(lipidmovie,
    [Scene(lipidmovie, frame, 1:60)],
    creategif=true,
    pathname="lipidmovie.gif")

bilayermovie = Movie(1500, 400, "Bilayer Movie")
function frame(scene::Scene, framenumber::Int64)
    background("white")
    norm_framenumber = rescale(framenumber,
        scene.framerange.start,
        scene.framerange.stop,
        0, 1)
    origin()
    draw_bilayer(123, norm_framenumber)
end
animate(bilayermovie,
    [Scene(bilayermovie, frame, 1:60)],
    creategif=true,
    pathname="bilayermovie.gif")
=#


