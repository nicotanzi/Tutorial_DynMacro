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

# ╔═╡ 5453899a-d160-41fd-973f-d1719ea87bef
using Plots; using Optim; using Interpolations; using LinearAlgebra; using PlutoUI

# ╔═╡ 6196a890-0360-11ec-37ed-ab3e1aba6300
md"""
# How to eat a cake?
*An step by step construction of the algorithm for Value Function Iteration to solve a simple recursive problem*

#### A simple cake eating problem

Suppose that you have a cake of size $K_0$. You can eat today the whole cake, but you will be hungry in the future. Or you can eat small pieces every day. The question is: *How much of the cake would you eat each day?*

Of course, preferences play an important role, we assume that you like eating cake, and that when you are eating it in any given day first slices seems tastier than the latter, which can be generalized in a instantaneous utility function which $u'(c)>0$ and $u''(c)<0$. Also, you are impatient, therefore we can assume that your intetemporal utility function is given by $U(\{c\}_{t=0}^\infty)=\sum_{t=0}^\infty \beta^t u(c_t)$. 

The unit of time are days represented by $t \in \{1;2;3;...T\}$. The cake does not spoil or grow, so $K_t=K_{t-1}-c_{t-1}$. So what to do?

If $T=2$ the problem is quite simple, we can use real analysis, that is we want to find $c^*\in \mathbb{R}^2$ that maximices the utility. If $T=\infty$ we have a problem, we are in a diferent *space*, no longer in $\mathbb{R}^n$. We are not looking for a vector we are looking for a sequence $\{c\}_{t=0}^\infty$, we can think about it as an infinite dimension vector, or as a function (that's why *function* analysis is used).
"""

# ╔═╡ de394195-68a8-43b3-8383-90679e3109f5
md"""
#### What would you do if you know that tomorrow the world ends?

It is a dramatic way to think the above problem with (a finete $T$) as if you were at time $T-1$. Let's write the problem a little more *Bellman*:

$V_{T-1}(K_{T-1})=max_{c_{T-1},c_T} \{ u(c_{T-1})+\beta u(c_T) \} \text{   subject to:   }K_{T-1}=c_{T-1}+c_T   \}$

With an easier notation, and knowing that the last period consumption will be $c_T=K_T$, so the value function of last period would be $V_T(K')=u(K')$

$V_{T-1}(K)=max_{c} \{ u(c)+\beta V(K') \} \text{   subject to:   } K'=K-c$


Suppose $u(c)=ln(c)$. It is easy to solve it with pen and paper. How to solve it with Julia?

Let put some numbers: $\beta=0.9$ $K_{T-1}=100$
"""

# ╔═╡ 2c8eab15-cafe-4b7b-a9e1-b14623262698
md"""
### How to put it in a computer?

I think it is useful to understand a simple method of how to find a maximun. It could give some intuition on how is a computer approach to optimization rather than the typical derivative equals 0 with pen and paper.

The mian idea is to try a lot of values for $c$ and take the one that gives the greatest value.

We know that $c\in [0,K]$, but there are infinite many options, so we discretizise the space. For example, since $K_0=100$ we can define $C=\{0,1,2,...,100\}$

Then we evaluate the function in everý point.

Finally we choose the greatest.
"""

# ╔═╡ 0bf0dc5b-4a7e-4535-a9f3-ac01361826df
# Create a vector C that is the discretized version of the consumtion domain avoiding ln(0)
C = 1:99

# ╔═╡ cdd5cd81-403f-47a5-94d9-684f54f7e294
# Define the parameters
K=100

# ╔═╡ 7b75b386-4f3d-4432-84ef-54f1fd9e8832
β=0.9

# ╔═╡ feabae5b-2a97-44fb-ac07-4cba38a58cba
# Define the objetive funcion
U(c,k) = log(c) + β * log(k-c)

# ╔═╡ cf51cf88-0875-4689-9682-419c507aa799
# Calculate the image of the function for the dicretized set C
U_img = U.(C,K)

# ╔═╡ a2425714-b5c6-4d3d-8a4d-3ffe4cccfc0f
# The point indicate that the operation is element wise, for each element of C

plot(C,U_img,label="U(c)") # first time takes time

# ╔═╡ 99d27937-da94-4ec4-8b3a-f6a1c200da52
# Let's take the maximun value
(V_T1,pos)=findmax(U_img)

# ╔═╡ 2905588e-8a95-49c2-9deb-5a6002e0a2cd
md"""
El valor máximo de la función objetivo es $(round(V_T1,digits=1)) y se encunetra en la posición $(pos)

"""

# ╔═╡ b7c6524d-b2c7-49b1-a64a-63229b93ec66
c_max = C[pos] # reduntante en este caso

# ╔═╡ 4ae7d87b-3afc-42b7-bdc2-32807ef50a88
md"""
El valor de consumo que maximiza la utilidad intertemporal es $(c_max)
"""

# ╔═╡ 631df85e-84c9-4d32-a198-d4423740ca71
md"""
#### Using a solver
The solver `Optim.jl` works fine for us
"""

# ╔═╡ ba50a3ff-2ace-46d9-b5f6-42474261a4a8
# Since K is fixed, define a specification of the function U(c,k) = log(c) + β * log(k-c), such that k=K
# So the solver will work with c.
U_k(c)=U(c,K)

# ╔═╡ c852dd19-b609-4239-86b4-667909a7e9af
# optimize(function, lower_bound, upper_bound, ...)
maximize(U_k, 0.0, 100.0)

# ╔═╡ e2c9c467-f9cd-484b-95ea-02f23543fe07
begin
	# For selecting a specific result
	result=maximize(U_k, 0.0, 100.0)
	V_solver = Optim.maximum(result)
	c_max_solver = Optim.maximizer(result)
end;

# ╔═╡ 48802a2a-1fa7-4ce8-a037-773664a66770
md"""
The maximum value of the malue function is $(round(V_solver,digits=2)) and the value of consumption that maximizes the value function is $(round(c_max_solver,digits=2))
"""

# ╔═╡ e6c4a309-b5ef-4447-a477-699d52a0b7a0
md"""

### What if the cake would  have been different?

We didn't find a *function* $V_{T-1}(K_{T-1})$. We found an specific value of its image given an specific value of $K_{T-1}$.

What is a *function*? For now, let's say it is set of order pairs, e.g. $f=\{(x,y):y=f(x)\}$, this is convinient for a computational perspective. Although, Julia can deal with closed form functions as we usually think of them, a more general approach is to *discretize* the domain and think of the function as a collection of points, the *graph* of the function.

So now we have to find $V_{T-1}(K_{T-1})$ for $K_{T-1}\in(0,100]$ for example. 

(An even more useful way to think about *functions* is to think of them as *interpolations*. You can read the notebook on *Interpolations* to understand them a lttle better).
"""

# ╔═╡ e8c6a508-1e39-429a-8663-2b13f067ddbc
begin
	grid_max = 100    # Largest grid point
	grid_size = 200    # Number of grid points
	K_grid = range(1e-5,  grid_max, length = grid_size)	
end

# ╔═╡ 9305f887-967d-4752-87b0-7c913c42af54
objectives = (c -> U(c,k) for k in K_grid) # objective for each grid point

# ╔═╡ e562b080-aca5-47a8-b4fa-a54eb70cbb72
begin
	results = maximize.(objectives, 1e-10, K_grid) # solver result for each grid point
	V_img = Optim.maximum.(results)    
	policy_img = Optim.maximizer.(results)
end

# ╔═╡ c5f3c076-978c-48df-ac11-0058dbc4efc9
begin
	p1=plot(K_grid, V_img, label="V(K)")
	p2=plot(K_grid,policy_img, label="g(K)", color=:orange, ylabel="c")
	plot(p1, p2, layout=(2,1))
end

# ╔═╡ 2120be72-c970-4504-96df-ecb460581a55
md"""
### What if there is another day before the end of the world?
Instead of thinking in a sequential way like this:

$V_{T-2}(K_{T-2})=max_{c_{T-2},c_{T-1},c_T} \big\{ u(c_{T-2})+\beta u(c_{T-1}) + \beta^2 u(c_T) \big\} \text{   subject to:   }K_{T-1}=K_{T-2}+c_{T-1}+c_T$

We can build on previous work. That is:

$V_{T-2}(K_{T-2})=max_{c_{T-2}} \big\{ u(c_{T-2}) + \beta V_{T-1}(K_{T-1}) \big\} \text{   subject to:   } K_{T-2}=K_{T-1}+c_{T-2}$

We already know the function $V_{T-1}(K)$. In fact, in orther to get the function $V_{T-2}(K)$ the process is almost the same. Again we have to find the value of $c$ that maximices that objective function for a *grid* of $K$.
"""

# ╔═╡ fd5f2f98-16c2-4553-9907-288615742132
md"""
Our previous definition of function think of them as points in the plane. Graphically:
"""

# ╔═╡ f6753f55-86ad-40f2-b712-5cd8a160fa56
scatter(K_grid,V_img)

# ╔═╡ 3a289aca-e816-482d-80dc-1d7df57702b9
md"""
We can conect those dots with a line and it would like more pretty, more *function-like* and it will be more useful. This function is defined only for values of $K$ in the *grid*, what if we want to value the function in-between points of the grid, for example at 1.5. Well, we can draw a line and see what results gives us. Mathematically, it would be $0.5V(1)+0.5V(2)$. If we want to evaluate 1.75 it would be  $0.25V(1)+0.75V(2). This is call a *linear interpolarion*, and it can be done easly with `Interpolations.jl` package.

You can read the notebook about *interpolations* to understand them better.
"""

# ╔═╡ 3ceec1b4-b2c1-432e-a3fa-f8c6df8c7797
# The previous V(K) now is an element of the objective function to maximize
# Linear Interpolation:
V_old = LinearInterpolation(K_grid,V_img,extrapolation_bc = Line());

# ╔═╡ f475315f-57b4-4706-a417-740bc59c2299
U_new(c,k) = log(c) + β * V_old(k-c);

# ╔═╡ 4b042066-81dd-4752-93b5-5d2cd7bba3df
objectives_new = (c -> U_new(c,k) for k in K_grid);

# ╔═╡ 674a64ed-27d0-43c8-a52b-c1cdc1573ade
begin
	results_new = maximize.(objectives_new, 1e-5, K_grid) 

	V_img_new = Optim.maximum.(results)    
	policy_img_new = Optim.maximizer.(results)
	
	p1_new=plot(K_grid, V_img_new, label="V(K)",title="A day before...")
	p2_new=plot(K_grid,policy_img_new, label="g(K)", color=:orange)
	plot(p1_new, p2_new, layout=(2,1))
end

# ╔═╡ cd3e2ccb-534b-4eb4-a995-165cdce9e9fc
md"""
### What happens n days before T?

We simply have to repeat the process. This process that goes backwards a day is called a mapping, which is another way to say function. For convention we will use mapping for something that *eats* functions and *spits* functions (instead of numbers).

So we have:

$V_{T-n}=T(V_{T-(n-1)})$

For simplicity, we can write:

$V_n=T(V_{n-1})$

"""

# ╔═╡ 1b73e0e6-8eb4-415f-a799-10807cae465c
md"""
### What if the world never ends? 

One remarkable thing about the above Bellman operator is that this mapping is a **contraction**, that is to say that in each step $V_n$ and $V_{n-1}$ are less *different*. In fact, there is a fixed point, in other words if $n\rightarrow\infty$ we would have that $V_n=V_{n-1}$.

This means that if the problem is infinitely long (as it usually is) we can still use this methodology, each iteration will make $V_n$ and $V_{n-1}$ closer and closer. They are not going to be identical but we can tolerate some small difference between them.
"""

# ╔═╡ ed97c976-8256-498f-a574-dd0b7be38b4f
# Defining T
function T(V_old, k_grid, β, u)
    V_fun = LinearInterpolation(k_grid, V_old, extrapolation_bc = Line())
    objectives = (c -> u(c) + β * V_fun(k-c) for k in k_grid)
    results = maximize.(objectives, 1e-10, K_grid) 
    V_new = Optim.maximum.(results)    
    policy_new = Optim.maximizer.(results)
    return V_new , policy_new
end

# ╔═╡ 5607c942-83e0-4858-bca0-3515d6ac59f4
V_0 = log.(K_grid) # initial condition

# ╔═╡ 15049144-afc3-4926-bda1-febafbde8c54
g_0=[K_grid;] # (not necessary). initial policy function

# ╔═╡ 2dccd8cf-0afc-4ef3-b33d-088897784af7
md"""
Define the number of iterations:

Iterations (`n`): $(@bind n Slider(2:100) )
"""

# ╔═╡ 5738bf6d-24a7-4121-9756-630bff1353c1
md" Iterations (`n`) = $(n) "

# ╔═╡ 36b6de8d-99ae-4570-bb89-fac0157628a8
let V_prev = log.(K_grid)
	
	pltV = plot(K_grid, V_prev, legend = :bottomright, ylim=(-50,25), 
		color = :black, linewidth = 2, alpha = 0.8, label = "initial condition")
	
	pltg = plot(K_grid, g_0,
		color = :black, linewidth = 2, alpha = 0.8, label = "initial condition")
	

	for i in 1:n
	    global V_next, g_next = T(V_prev, K_grid, β, log)
		V_prev = V_next
	end
	
	plot!(pltV, K_grid, V_next, label = "Final Condition", color = :maroon,
		title = "Value Function Iteration", linewidth = 2, alpha = 0.6 )
	
	plot!(pltg, K_grid, g_next, label = "Final Condition", color = :maroon,
		title = "Policy Function", linewidth = 2, alpha = 0.6 )

	plot(pltV, pltg)
	
end

# ╔═╡ da709847-df34-42db-9e6e-b825262ade12
md"""
### Was that enough?

In the previous code I iterated $n$ times. But was that enough? The idea is to get a *fixed point* (or loosly speaking a *fixed function*). However, it is not necessary for $V_n$ and $V_{n+1}$ to be exactly the same, if they are *close enough* it's ok. That brings two questions: What is *close*? What is *enough*?

Maybe some mesurement of how similar they are would be useful. Tinking in how similar two things are it is a littletricky. What is exactly means for two functions to be *the same* in this context? $\infty$?
Actually, it is better to *measure* how *different* they are. If this *difference measure* of two functions is 0, then they are the same function. And if the two functions became more different between each other, then the *measured difference*  grows. So the rule would be to make this *measured difference* as close to 0, as we would tolerate. For example if this *measurment of difference* is lesser than `1e-5` (0.00001) we wold be fine. Tinking in how similar two things are it is a little more tricky, what is exactly the same in this context? $\infty$?.

So we have to measure difference between two functions, it may be easier to think in an easier space first. Let's go back to real analysis: How can you measure difference between two real numbers? $|x-y|$ this difference is better known as **distance**. How can we measure *distance* in a plane? Pitagoras already told us that. There are many ways of measuring the *difference* of two things, that is to say of calculating the *distance* between them. This concept of *distance* it is key in Calculus, and it is key in functional analysis (Calculus in bigger spaces).

One last comment, there are two closely related concepts *distance* and *norm*, the mian difference is you calculate the *distance* of two things, while you calculate the *norm* of a single element. For example, let's think in $\mathbb{R}$, $|\;|$ is a norm, so we now that $|-5|=5$; that *norm* induce a *distance* (a way of measuring how differents two things are) that is $d(x,y)=|x-y|$, so the *distance* between 2 and 5 is $d(2,5)=|2-5|=|-3|=3$. In Julia with the `LinearAlgebra.jl` package we are provided with a function called `norm`, that do what the name says, so we can use ir to induce a *distance*.

Suppose $a$ is a real vector (or iterable) such that $a=[a_1,a_2,a_3,...a_N]$. Julia's LinearAlgebra default norm is:
$`norm(a)`=\sqrt{\sum_{i=1}^N a_i^2}$
Which induce de Pitagora's distance `distance_pitagoras(a,b)=norm(a-b)`.

Usually in function analysis we use the *supremum norm* in vectors terms at which elements there si the biggest difference. This is also already built in the `LinearAlgebra.jl` package adding the appropieta argument to the `norm` funtion. For example `norm(V_new - V_old , Inf)`. The term `Inf`referes to infinity in Julia, and it is usually how the supremum norm is represented.

Supremum norm of function $f$:    $||f||_\infty$

Supremum distance between $f$ and $g$:    $d(f,g)=||f-g||_\infty$

Since we are actually working with vectors, that aproximate functions, then we could use the *pitagorean norm*, but let use the *supremum norm* to be consistent with the theory.

This implementation is located 
"""

# ╔═╡ f58f47f6-06cc-481f-a9b4-4d4bcc6c91c8
md" Tolerance level: $( @bind tolerance Slider(range(1e-10,1e-5, length=100)))"

# ╔═╡ b2e9bcd7-3a2a-45b1-aa2c-5aba1df9fe20
md" `tolerance` = $tolerance "

# ╔═╡ c27b8905-df17-49f7-bc74-f2be31cc95a5
md" Maximum amount of iterations: $( @bind max_iter Slider(2:200))"

# ╔═╡ 91b69b0f-f2ac-403b-9e33-071d1fcde3a3
md" `max_iter` = $max_iter "

# ╔═╡ a6515cc5-0c5d-4444-9d49-f560acd54649
let V_ant = V_0
	distance = tolerance+1; # some initial condition for distance
	
	pltV2 = plot(K_grid, V_0, color = :black, linewidth = 2, alpha = 0.8, label = "initial condition")
	
	pltg2 = plot(K_grid, g_0, color = :black, linewidth = 2, alpha = 0.8, label = "initial condition")
	
	for i in 1:max_iter
		
		V_post, g_post = T(V_ant, K_grid, β, log)
		
		plot!(pltV2, K_grid, V_post, color = RGBA(i/max_iter, 0, 1 - i/max_iter, 0.8), linewidth = 2, alpha = 0.6, label = "")
		
		plot!(pltg2, K_grid, g_post, color = RGBA(i/max_iter, 0, 1 - i/max_iter, 0.8),  linewidth = 2, alpha = 0.6, label = "")
		
		distance = norm(V_post - V_ant, Inf)
		if distance < tolerance || i == max_iter
			global V_final = V_post
			global g_final = g_post
			global texto = md" After $(i) iterations the loop ended,
			the distance between the two last Value functions is: $(distance)"
			break
		end
		V_ant = V_post  # copy contents into v.  Also could have used v[:] = v_next
	end
	plot(pltV2,pltg2)	
end

# ╔═╡ 667ee197-4d4f-4dd3-b7e9-d8ffbb13110d
texto

# ╔═╡ 7a1396bf-bb23-44d5-a5f9-29fa558a7f68
md"""
### Cake eating dynamics

So... How to eat a cake? The value function doesn't tell us directly how to eat it. The policy function tell us how much you should eat today given some cake size. That is $c^*_t=g(K_t)$. Using the law of motion of the cake ($K_t=K_{t-1}-c_t)$ and an initial condition $K_0=\bar{K}$, we can compute the evolution of the cake.

Deine a value for the initial condition $K_0$ and the time horizon variable `Time`

``K_0: ``    $(@bind K_0 Slider(range(1, 100, length=100)))

`Time: `    $(@bind Time Slider(range(1, 100, length=100)))


"""

# ╔═╡ a50f931d-9a7d-4fb5-8e46-55887af8046d
md"""
``K_0 =`` $K_0

`Time` = $Time

"""

# ╔═╡ 33eefa77-a3bd-48c1-b24b-7f2bd043dca4
g_fun = LinearInterpolation(K_grid, g_final, extrapolation_bc = Line())

# ╔═╡ 003d1481-3f1b-46c9-88e0-bed8315f260e
# Function that computes the evolution
function cake_path(T,K_0)
    K_path = ones(T+1)
    c_path = ones(T+1)
    K_path[1] = K_0
    c_path[1] = g_fun(K_0)
    for t in 2:(T+1)  
        K_path[t] = K_path[t-1] - c_path[t-1]
        c_path[t] = g_fun( K_path[t] )
    end
    return K_path, c_path
end

# ╔═╡ 2f7663f1-b8df-479c-a0d8-dcfcb6e523f4
example_k_path,example_c_path=cake_path(Time,K_0)

# ╔═╡ e21bd98f-c542-420a-b181-2a5286803ae7
plot(0:Time, example_k_path, label="Cake size",
	title="Dynamics of cake-eating", xlabel="Time")

# ╔═╡ 0081b560-7816-4171-ac8c-3b1685698d46
plot(0:Time,example_c_path,label="Consumption")

# ╔═╡ Cell order:
# ╟─6196a890-0360-11ec-37ed-ab3e1aba6300
# ╟─de394195-68a8-43b3-8383-90679e3109f5
# ╟─2c8eab15-cafe-4b7b-a9e1-b14623262698
# ╠═0bf0dc5b-4a7e-4535-a9f3-ac01361826df
# ╠═feabae5b-2a97-44fb-ac07-4cba38a58cba
# ╠═cdd5cd81-403f-47a5-94d9-684f54f7e294
# ╠═7b75b386-4f3d-4432-84ef-54f1fd9e8832
# ╠═cf51cf88-0875-4689-9682-419c507aa799
# ╠═a2425714-b5c6-4d3d-8a4d-3ffe4cccfc0f
# ╠═99d27937-da94-4ec4-8b3a-f6a1c200da52
# ╟─2905588e-8a95-49c2-9deb-5a6002e0a2cd
# ╠═b7c6524d-b2c7-49b1-a64a-63229b93ec66
# ╟─4ae7d87b-3afc-42b7-bdc2-32807ef50a88
# ╟─631df85e-84c9-4d32-a198-d4423740ca71
# ╠═ba50a3ff-2ace-46d9-b5f6-42474261a4a8
# ╠═c852dd19-b609-4239-86b4-667909a7e9af
# ╠═e2c9c467-f9cd-484b-95ea-02f23543fe07
# ╠═48802a2a-1fa7-4ce8-a037-773664a66770
# ╟─e6c4a309-b5ef-4447-a477-699d52a0b7a0
# ╠═e8c6a508-1e39-429a-8663-2b13f067ddbc
# ╠═9305f887-967d-4752-87b0-7c913c42af54
# ╠═e562b080-aca5-47a8-b4fa-a54eb70cbb72
# ╠═c5f3c076-978c-48df-ac11-0058dbc4efc9
# ╟─2120be72-c970-4504-96df-ecb460581a55
# ╟─fd5f2f98-16c2-4553-9907-288615742132
# ╟─f6753f55-86ad-40f2-b712-5cd8a160fa56
# ╟─3a289aca-e816-482d-80dc-1d7df57702b9
# ╠═3ceec1b4-b2c1-432e-a3fa-f8c6df8c7797
# ╠═f475315f-57b4-4706-a417-740bc59c2299
# ╠═4b042066-81dd-4752-93b5-5d2cd7bba3df
# ╠═674a64ed-27d0-43c8-a52b-c1cdc1573ade
# ╟─cd3e2ccb-534b-4eb4-a995-165cdce9e9fc
# ╟─1b73e0e6-8eb4-415f-a799-10807cae465c
# ╠═ed97c976-8256-498f-a574-dd0b7be38b4f
# ╠═5607c942-83e0-4858-bca0-3515d6ac59f4
# ╠═15049144-afc3-4926-bda1-febafbde8c54
# ╟─2dccd8cf-0afc-4ef3-b33d-088897784af7
# ╟─5738bf6d-24a7-4121-9756-630bff1353c1
# ╠═36b6de8d-99ae-4570-bb89-fac0157628a8
# ╟─da709847-df34-42db-9e6e-b825262ade12
# ╟─f58f47f6-06cc-481f-a9b4-4d4bcc6c91c8
# ╟─b2e9bcd7-3a2a-45b1-aa2c-5aba1df9fe20
# ╟─c27b8905-df17-49f7-bc74-f2be31cc95a5
# ╟─91b69b0f-f2ac-403b-9e33-071d1fcde3a3
# ╟─667ee197-4d4f-4dd3-b7e9-d8ffbb13110d
# ╠═a6515cc5-0c5d-4444-9d49-f560acd54649
# ╟─7a1396bf-bb23-44d5-a5f9-29fa558a7f68
# ╟─a50f931d-9a7d-4fb5-8e46-55887af8046d
# ╠═e21bd98f-c542-420a-b181-2a5286803ae7
# ╠═0081b560-7816-4171-ac8c-3b1685698d46
# ╠═33eefa77-a3bd-48c1-b24b-7f2bd043dca4
# ╠═003d1481-3f1b-46c9-88e0-bed8315f260e
# ╠═2f7663f1-b8df-479c-a0d8-dcfcb6e523f4
# ╠═5453899a-d160-41fd-973f-d1719ea87bef
