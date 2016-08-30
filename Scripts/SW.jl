include("read_graph.jl")

print("The condition of Small-World-Ness according to [this paper](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0002051) is that S > 1 \n \n")
#global_clustering_coefficient(gigante)

gigante = induced_subgraph(g,connected_components(g)[1])

eccent = eccentricity(gigante)
Floye_Warshall = floyd_warshall_shortest_paths(gigante)


grados = Array(Int64,0)
for i in vertices(gigante)
  push!(grados,degree(gigante,i))
end

clustering_coef = global_clustering_coefficient(gigante)
promedio_grados = sum(grados)/nv(gigante)
mean_spl = sum(Floye_Warshall.dists)/((4214*4214)-4214)
log(nv(gigante))

S = (clustering_coef/mean_spl)*((nv(gigante)*log(nv(gigante)))/(promedio_grados*log(promedio_grados)))

print("Your network has a S = $S small world coefficient. \n \n")

# Lo de abajo es una aproximación al mismo coeficiente
#β = mean_spl/log(nv(gigante))
#α = clustering_coef/(β*promedio_grados*log(promedio_grados))
#ξ = 2*ne(gigante)/(nv(gigante)*(nv(gigante)-1))
#other = promedio_grados*α/ξ
#print("It must be equivalent to S = $(other). \n")
