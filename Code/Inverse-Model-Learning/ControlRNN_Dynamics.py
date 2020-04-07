import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import os
from tensorflow import keras
import tensorflow as tf

# Hyperparameters
epochs = 1200

## Dataset preparation and segmentation
# X_train preparation
x_pos = np.array(pd.read_csv("Datasets_Dynamics/x.csv"))
y_pos = np.array(pd.read_csv("Datasets_Dynamics/y.csv"))
th1_head = np.array(pd.read_csv("Datasets_Dynamics/th1.csv"))
th0_head = np.array(pd.read_csv("Datasets_Dynamics/th0.csv"))
print(x_pos.shape, y_pos.shape, th1_head.shape, th0_head.shape)

X = np.array([x_pos, y_pos, th1_head, th0_head]).T
print(X, X.shape)

# Y_train preparation
tau1_tau2 = np.array(pd.read_csv("Datasets_Dynamics/tau.csv"))
length = tau1_tau2.shape[1]
slice = int(length/2)
tau1 = tau1_tau2[:, :slice]
tau2 = tau1_tau2[:, slice:]
print(tau1.shape, tau2.shape)

Y = np.array([tau1, tau2]).T
print(Y, Y.shape)

# # segmentation
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

# # Logger
root_logdir = os.path.join(os.curdir, "Dynamics_logs")
def get_run_logdir():
    import time
    run_id = time.strftime("run_%Y_%m_%d-%H_%M_%S")
    return os.path.join(root_logdir, run_id)
run_logdir = get_run_logdir()
file_writer = tf.summary.create_file_writer(run_logdir + "/metrics")
file_writer.set_as_default()

# # Learning Rate Scheduler
def exponential_decay(lr0, s):
    def exponential_decay_fn(epoch):
        lr = lr0 * 0.1 ** (epoch/s)
        tf.summary.scalar('learning rate', data=lr, step=epoch)
        return lr
    return exponential_decay_fn
exponential_decay_fn = exponential_decay(lr0=0.01, s=epochs)

# # Callbacks
checkpoint_cb = keras.callbacks.ModelCheckpoint("Models/ControlRNN_Dynamics.h5", save_freq=20)
lr_scheduler = keras.callbacks.LearningRateScheduler(exponential_decay_fn)
tensorboard_cb = keras.callbacks.TensorBoard(run_logdir)
callbacks = [tensorboard_cb, checkpoint_cb, lr_scheduler]

# # Deep Recurring Neural Network
# Neuron dimension heads-up
batch_size = X_train.shape[0]
dim_in = X_train.shape[2]
dim_out = Y_train.shape[2]
nb_units = 10
model = keras.models.Sequential([keras.layers.Bidirectional(keras.layers.LSTM(batch_input_shape=(batch_size, None, dim_in), return_sequences=True, units=nb_units)),
                                 keras.layers.BatchNormalization(),     
                                 keras.layers.Bidirectional(keras.layers.LSTM(50, return_sequences=True)),
                                 keras.layers.BatchNormalization(),
                                 keras.layers.Bidirectional(keras.layers.LSTM(30, return_sequences=True)),
                                 keras.layers.BatchNormalization(),
                                 keras.layers.Bidirectional(keras.layers.LSTM(10, return_sequences=True)),
                                 keras.layers.BatchNormalization(),
                                 keras.layers.TimeDistributed(keras.layers.Dense(dim_out))
                                 ])
model.compile(loss="mean_squared_error", optimizer=optimiser)
history = model.fit(X_train, Y_train, epochs=epochs, validation_data=(X_valid, Y_valid), callbacks=callbacks)
mse_test = model.evaluate(X_test, Y_test)
Y_pred = model.predict(X[-1:,:])

print(Y_pred, Y_pred.shape)
print(mse_test)

np.savetxt('Datasets_Dynamics/PredictedTorques.csv', np.squeeze(Y_pred, axis=0), delimiter=",")

def plotting(history):
   plt.plot(history.history['loss'], color = "red")
   plt.plot(history.history['val_loss'], color = "blue")
   red_patch = mpatches.Patch(color='red', label='Training')
   blue_patch = mpatches.Patch(color='blue', label='Test')
   plt.legend(handles=[red_patch, blue_patch])
   plt.xlabel('Epochs')
   plt.ylabel('MSE loss')
   plt.show()

plotting(history)
