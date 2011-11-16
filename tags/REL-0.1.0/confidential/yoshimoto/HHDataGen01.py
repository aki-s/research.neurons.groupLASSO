'''
Created on 2010/11/19

@author: jun-y
'''
# Import packages
import sys, nest

# Set a file name to export the simulation data
fname_prefix = "HH00"
if __name__ == '__main__':
    if len(sys.argv) >= 2:
        fname_prefix = sys.argv[1]
        
# Set the seed of random number generator
seed = 0
if __name__ == '__main__':
    if len(sys.argv) >= 3:
        seed = int(sys.argv[2])

# Initialize NEST Kernel        
nest.ResetKernel()
nest.SetKernelStatus({"overwrite_files": True})

# Initialize the random number generator
tmp = nest.GetKernelStatus(['total_num_virtual_procs'])
if len(tmp) == 0:
    N_vp = 0
else:
    N_vp = int(tmp[0])
        
nest.SetKernelStatus({'grng_seed': seed + N_vp})
nest.SetKernelStatus({'rng_seeds': range(seed + N_vp + 1, seed + 2 * N_vp + 1)})

# Create a model where two neurons is innervated by Poisson spikes.
neuron1 = nest.Create("hh_psc_alpha",5,{'tau_syn_ex': 5.0, 'tau_syn_in': 10.0})
neuron2 = nest.Create("hh_psc_alpha",5,{'tau_syn_ex': 5.0, 'tau_syn_in': 10.0})
neuron3 = nest.Create("hh_psc_alpha",5,{'tau_syn_ex': 5.0, 'tau_syn_in': 10.0})
# dc1=nest.Create("dc_generator",5,{'amplitude': 600.0})
noise1 = nest.Create("poisson_generator",5)
nest.SetStatus(noise1,{"rate": 150.0}) # 150.0
noise2 = nest.Create("poisson_generator",5)
nest.SetStatus(noise2,{"rate": 50.0}) # 50.0
noise3 = nest.Create("poisson_generator",5)
nest.SetStatus(noise3,{"rate": 50.0}) # 50.0

nest.Connect(noise1,neuron1,{"weight": 100.0}) # 100.0
#nest.Connect(dc1,neuron1) # 300.0
nest.Connect(noise2,neuron2,{"weight": 100.0}) # 100.0
nest.Connect(noise3,neuron3,{"weight": 100.0}) # 100.0 

nest.DivergentConnect(neuron1,neuron2,120.0,1.0) # 150.0
nest.DivergentConnect(neuron2,neuron3,120.0,1.0) # 150.0
nest.DivergentConnect(neuron3,neuron1,-180.0,1.0) # -200.0

# Connect neuron 1 to neuron 2
#nest.Connect(neuron[0:1],neuron[1:2],{"weight": 200.0})
# Connect neuron 2 to neuron 3
#nest.Connect(neuron[1:2],neuron[2:3],{"weight": 200.0})
# Connect neuron 3 to neuron 2
#nest.Connect(neuron[2:3],neuron[1:2],{"weight": -200.0})

# Set the voltage meter
vm = nest.Create("voltmeter")
nest.SetStatus(vm, [{"to_file": False, "withtime": True, "to_screen": False, "interval": 2.0}])
nest.DivergentConnect(vm, neuron1);
nest.DivergentConnect(vm, neuron2);
nest.DivergentConnect(vm, neuron3);

# Run the simulation
nest.Simulate(600002.0)

# Collect the simulated data
N_neuron=len(neuron1)+len(neuron2)+len(neuron3)
senders = nest.GetStatus(vm,'events')[0]['senders']
t = nest.GetStatus(vm,'events')[0]['times']
V = nest.GetStatus(vm, "events")[0]['V_m']

# Export the simulated data to a file
filename = 'data/%(prefix)s_%(index)03d_voltage.dat' % {"prefix": fname_prefix, "index": seed}
f_out=open(filename,'w')
for n in range(len(senders)):
    str_data='%(index)d\t%(time)g\t%(voltage)g\n' %{"index": senders[n], "time": t[n], "voltage": V[n]}
    f_out.write(str_data)
f_out.close()
