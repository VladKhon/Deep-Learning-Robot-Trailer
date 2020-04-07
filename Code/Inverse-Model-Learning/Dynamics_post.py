import numpy as np
import pandas as pd
from tensorflow import keras

# # Dataset preparation and segmentation
# X_train preparation
x_pos = np.array(pd.read_csv("Datasets_Dynamics/1env/x.csv"))
y_pos = np.array(pd.read_csv("Datasets_Dynamics/1env/y.csv"))
th1_head = np.array(pd.read_csv("Datasets_Dynamics/1env/th1.csv"))
th0_head = np.array(pd.read_csv("Datasets_Dynamics/1env/th0.csv"))
print(x_pos.shape, y_pos.shape, th1_head.shape, th0_head.shape)

X = np.array([x_pos, y_pos, th1_head, th0_head]).T
print(X, X.shape)

# Y_train preparation
tau1_tau2 = np.array(pd.read_csv("Datasets_Dynamics/1env/tau.csv"))
length = tau1_tau2.shape[1]
slice = int(length/2)
tau1 = tau1_tau2[:, :slice]
tau2 = tau1_tau2[:, slice:]
print(tau1.shape, tau2.shape)

Y = np.array([tau1, tau2]).T
print(Y, Y.shape)

# # segmentation
batch_size = X.shape[0]
print(batch_size)
train_size = int(batch_size * 0.7)
valid_size = int(batch_size * 0.9)
last_one = int(batch_size - 1)

print(train_size, valid_size)
X_train, Y_train = X[:train_size,:], Y[:train_size,:]
print(X_train.shape, Y_train.shape)
X_valid, Y_valid = X[train_size:valid_size,:], Y[train_size:valid_size,:]
print(X_valid.shape, Y_valid.shape)
X_test, Y_test = X[valid_size:,:], Y[valid_size:,:]
print(X_test.shape, Y_test.shape)

# # Deep Recurring Neural Network
# Neuron dimension heads-up
dim_in = X_train.shape[2]
dim_out = Y_train.shape[2]
nb_units = 10
# model = keras.models.Sequential([keras.layers.Bidirectional(keras.layers.LSTM(batch_input_shape=(batch_size, None, dim_in), return_sequences=True, units=nb_units)),
#                                  keras.layers.BatchNormalization(),
#                                  keras.layers.Bidirectional(keras.layers.LSTM(50, return_sequences=True)),
#                                  keras.layers.BatchNormalization(),
#                                  keras.layers.Bidirectional(keras.layers.LSTM(30, return_sequences=True)),
#                                  keras.layers.BatchNormalization(),
#                                  keras.layers.Bidirectional(keras.layers.LSTM(10, return_sequences=True)),
#                                  keras.layers.BatchNormalization(),
#                                  keras.layers.TimeDistributed(keras.layers.Dense(dim_out))
#                                  ])
# model.build([batch_size, None, dim_in])
model = keras.models.load_model("Models/ControlRNN_Dynamics_Simple.h5")
model.compile(loss='mean_squared_error', optimizer='Adam')
model.summary()
mse_test = model.evaluate(X_test, Y_test)
Y_pred = model.predict(X[-1:,:])

print(Y_pred, Y_pred.shape)
print(mse_test)

np.savetxt('Datasets_Dynamics/PredictedTorques.csv', np.squeeze(Y_pred, axis=0), delimiter=",")