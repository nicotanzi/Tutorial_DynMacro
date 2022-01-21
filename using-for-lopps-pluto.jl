### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ de620b67-5b72-4c76-8afe-f9ea16579525
using Plots; using PlutoUI

# ╔═╡ f7ce5d11-0b60-4ceb-a082-fc64dd0ac4ba
md"""
# Using for loops in Pluto

### A simple fixed point example

"""

# ╔═╡ b8e978c8-0587-4aa6-9d55-bde4e5c9d4c2
md"""
Let define the parameters of the above function

``a: ``    $(@bind a Slider(range(1, 100, length=100)))

``b: `` $(@bind b Slider(range(0.01,0.99,length=99)))


"""

# ╔═╡ 57886b40-0383-11ec-1eac-29b128877223
f(x) = a + b*x

# ╔═╡ 048d1e8f-c08a-4122-b91a-04a7d2b6a26b
md"""
The function is ``f(x)=`` $(a) ``+`` $(b) ``x``
"""

# ╔═╡ 98b7f635-f770-4a8e-869d-b0eb2a430c96
md"""

Define an initial condition for $x$

``x_0:`` $(@bind x_0 Slider(range(0, 100,length=101)))


"""

# ╔═╡ 12d34524-e046-4db6-999a-101dc455656f
md"""
``x_0 = ``$(x_0)
"""

# ╔═╡ e926ba16-f1c6-4f5d-b3ad-e7592a5ea9e5
md"""

Set the number of iterations

Iterations: $(@bind iter Slider(range(2, 100,length=99)))

"""

# ╔═╡ 318e8fe4-22de-45df-99f4-b7f6da90e760
iter

# ╔═╡ 4dfdca5b-6786-4690-861c-82b74e9f1aa0
let x_old = x_0
	for i in 1:iter
		global x_new = f(x_old)
		x_old = x_new
	end
	md" fixed point at $(x_new)"
end

# ╔═╡ f4965898-1601-4b59-acfb-249323a6988f
md"""
The loop requires to introduce a `let` block. Which allows to define a varible in another scope. This allows to redifine `x_old` in the above example.

"""

# ╔═╡ Cell order:
# ╟─f7ce5d11-0b60-4ceb-a082-fc64dd0ac4ba
# ╠═57886b40-0383-11ec-1eac-29b128877223
# ╟─b8e978c8-0587-4aa6-9d55-bde4e5c9d4c2
# ╟─048d1e8f-c08a-4122-b91a-04a7d2b6a26b
# ╟─98b7f635-f770-4a8e-869d-b0eb2a430c96
# ╟─12d34524-e046-4db6-999a-101dc455656f
# ╟─e926ba16-f1c6-4f5d-b3ad-e7592a5ea9e5
# ╟─318e8fe4-22de-45df-99f4-b7f6da90e760
# ╠═4dfdca5b-6786-4690-861c-82b74e9f1aa0
# ╟─f4965898-1601-4b59-acfb-249323a6988f
# ╠═de620b67-5b72-4c76-8afe-f9ea16579525
