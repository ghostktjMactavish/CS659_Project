from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import absolute_import
from builtins import *
from future import standard_library
standard_library.install_aliases()
from os import path
import math
import array
import sys

import gym
import gym.spaces
import functools

import chainer
from chainer import functions as F
from chainer import links as L
import numpy as np

import chainerrl
from chainerrl.agents import a3c
from chainerrl import experiments
from chainerrl import links
from chainerrl import misc
from chainerrl.optimizers.nonbias_weight_decay import NonbiasWeightDecay
from chainerrl.optimizers import rmsprop_async
from chainerrl import policies
from chainerrl.recurrent import Recurrent
from chainerrl.recurrent import RecurrentChainMixin
from chainerrl import v_function
from chainerrl.agents.dqn import DQN
from chainerrl import explorers
from chainerrl import q_functions
from chainerrl import replay_buffer
from chainerrl.replay_buffer import EpisodicReplayBuffer
from chainerrl import v_functions

#import os
#os.environ['HDF5_DISABLE_VERSION_CHECK'] = 1
class A3CModel(chainer.Link):
    """A3C model."""

    def pi_and_v(self, obs):
        """Evaluate the policy and the V-function.

        Args:
            obs (Variable or ndarray): Batched observations.
        Returns:
            Distribution and Variable
        """
        raise NotImplementedError()

    def __call__(self, obs):
        return self.pi_and_v(obs)

class A3CFFSoftmax(chainer.ChainList, a3c.A3CModel):
    """An example of A3C feedforward softmax policy."""

    def __init__(self, ndim_obs, n_actions, hidden_sizes=(200, 200)):
        print('Inside A3CFF')
        print(n_actions)
        self.pi = policies.SoftmaxPolicy(
            model=links.MLP(ndim_obs, n_actions, hidden_sizes))
        self.v = links.MLP(ndim_obs, 1, hidden_sizes=hidden_sizes)
        super().__init__(self.pi, self.v)

    def pi_and_v(self, state):
        return self.pi(state), self.v(state)


class A3CLSTMGaussian(chainer.ChainList, a3c.A3CModel, RecurrentChainMixin):
    """An example of A3C recurrent Gaussian policy."""

    def __init__(self, obs_size, action_size, hidden_size=200, lstm_size=128):
        self.pi_head = L.Linear(obs_size, hidden_size)
        self.v_head = L.Linear(obs_size, hidden_size)
        self.pi_lstm = L.LSTM(hidden_size, lstm_size)
        self.v_lstm = L.LSTM(hidden_size, lstm_size)
        self.pi = policies.FCGaussianPolicy(lstm_size, action_size)
        self.v = v_function.FCVFunction(lstm_size)
        super().__init__(self.pi_head, self.v_head,
                         self.pi_lstm, self.v_lstm, self.pi, self.v)

    def pi_and_v(self, state):

        def forward(head, lstm, tail):
            h = F.relu(head(state))
            h = lstm(h)
            return tail(h)

        pout = forward(self.pi_head, self.pi_lstm, self.pi)
        vout = forward(self.v_head, self.v_lstm, self.v)

        return pout, vout



def phi(obs):
    return obs.astype(np.float32)

def make_a3c_agent(obs_space_dim, action_space_dim):
    gamma = 1
    obs_low = np.array([-1] * obs_space_dim,dtype=np.float32)
    obs_high = np.array([1] * obs_space_dim,dtype=np.float32)
    ac_low = np.array([-1] * action_space_dim,dtype=np.float32)
    ac_high = np.array([1] * action_space_dim,dtype=np.float32)
    #print('Action Bounds')
    #print(ac_low,ac_high)
    obsSpace = gym.spaces.Box(obs_low, obs_high)
    actSpace = gym.spaces.Box(ac_low, ac_high)
    #print(actSpace)
    model = A3CLSTMGaussian(obs_space_dim, action_space_dim)

    optimizer = chainer.optimizers.Adam(eps=1e-2)
    optimizer.setup(model)
    optimizer.add_hook(chainer.optimizer.GradientClipping(40))
    agent = a3c.A3C(model, optimizer, t_max=5, gamma=0.99,
                    beta=0.65)
    #explorer = explorers.AdditiveGaussian(scale=0.5,low=ac_low,high=ac_high)
    #explorer = explorers.Boltzmann(T=1.0)
    #rand_ac = lambda : 2*np.random.rand(action_space_dim)-1.0
    #explorer = explorers.ConstantEpsilonGreedy(epsilon=0.1,random_action_func=rand_ac)

    # Use AdditiveOU for exploration
    #ou_sigma = (actSpace.high - actSpace.low) * 0.25
    #explorer = explorers.AdditiveOU(sigma=ou_sigma)

    #replay_buffer = chainerrl.replay_buffer.ReplayBuffer(capacity=10 ** 4)
    #phi = lambda x: x.astype(np.float32, copy=False)
    #agent = chainerrl.agents.DoubleDQN(
    #        qFunc, optimizer, replay_buffer, gamma, explorer,
    #    replay_start_size=5000, update_interval=1,
    #    target_update_interval=100, phi=phi)
    return agent


agent = make_a3c_agent(4,2)

def train(algo, obs_space_dim, action_space_dim, alpha_arg):
    global agent
    global alpha
    alpha = alpha_arg
    algo = 'a3C'
    obs_space_dim = int(obs_space_dim)
    action_space_dim = int(action_space_dim)
    #print(action_space_dim)
    agent = make_a3c_agent(obs_space_dim, action_space_dim)

def update(state, r):
    reward = math.exp( - alpha * r) - 1.0
    state = np.array(state, np.float32)
    action = agent.act_and_train(state, reward)
    action = np.minimum(1.0, np.maximum(-1.0, action))
    return array.array('d', action.tolist())

def act(state):
    state = np.array(state, dtype=np.float32)
    action = agent.act(state)
    #print(action)
    action = np.minimum(1.0, np.maximum(-1.0, action))
    #u =  array.array('d', action.tolist())
    u =  np.array(action.tolist(),dtype=np.float32)
    #print(u)
    #print(np.array([0.0,0.0]))
    return u

def stop_episode():
    #Prepare for a new episode.
    agent.stop_episode()

def stop_episode_and_train(state, reward):
    #Observe consequences and prepare for a new episode.
    s = np.array(state, np.float32)
    agent.stop_episode_and_train(s, reward)

def save(savedir):
    agent.save(savedir)

def load(loaddir):
    agent.load(loaddir)

def hello():
    print("Hello New World A3C")
