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

def phi(obs):
    return obs.astype(np.float32)

def make_ddqn_agent(obs_space_dim, action_space_dim):
    gamma = 1
    obs_low = np.array([-1] * obs_space_dim,dtype=np.float32)
    obs_high = np.array([1] * obs_space_dim,dtype=np.float32)
    ac_low = np.array([-1] * action_space_dim,dtype=np.float32)
    ac_high = np.array([1] * action_space_dim,dtype=np.float32)
    obsSpace = gym.spaces.Box(obs_low, obs_high)
    actSpace = gym.spaces.Box(ac_low, ac_high)

    qFunc = q_functions.FCQuadraticStateQFunction(
            obsSpace.low.size, actSpace.low.size,
            n_hidden_channels=50,
            n_hidden_layers=2,
            action_space=actSpace)
    optimizer = chainer.optimizers.Adam(eps=1e-2)
    optimizer.setup(qFunc)
    #explorer = explorers.AdditiveGaussian(scale=0.5,low=ac_low,high=ac_high)
    #explorer = explorers.Boltzmann(T=1.0)
    #rand_ac = lambda : 2*np.random.rand(action_space_dim)-1.0
    #explorer = explorers.ConstantEpsilonGreedy(epsilon=0.1,random_action_func=rand_ac)

    # Use AdditiveOU for exploration
    ou_sigma = (actSpace.high - actSpace.low) * 0.25
    explorer = explorers.AdditiveOU(sigma=ou_sigma)

    replay_buffer = chainerrl.replay_buffer.ReplayBuffer(capacity=10 ** 4)
    phi = lambda x: x.astype(np.float32, copy=False)
    agent = chainerrl.agents.DoubleDQN(
        qFunc, optimizer, replay_buffer, gamma, explorer,
        replay_start_size=5000, update_interval=1,
        target_update_interval=100, phi=phi)
    return agent

agent = make_ddqn_agent(4,2)

def train(algo, obs_space_dim, action_space_dim, alpha_arg):
    global agent
    global alpha
    alpha = alpha_arg
    algo = 'DDQN'
    obs_space_dim = int(obs_space_dim)
    action_space_dim = int(action_space_dim)
    agent = make_ddqn_agent(obs_space_dim, action_space_dim)

def update(state, r):
    reward = math.exp( - alpha * r) - 1.0
    state = np.array(state, np.float32)
    action = agent.act_and_train(state, reward)
    action = np.minimum(1.0, np.maximum(-1.0, action))
    return array.array('d', action.tolist())

def act(state):
    state = np.array(state, dtype=np.float32)
    action = agent.act(state)
    action = np.minimum(1.0, np.maximum(-1.0, action))
    #u =  array.array('d', action.tolist())
    u =  np.array(action.tolist(),dtype=np.float32)

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
    print("Hello New World 1")
