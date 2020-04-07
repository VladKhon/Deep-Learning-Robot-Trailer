import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import os
import tensorflow as tf
from tensorflow import keras

## REVERSED I/O

# Hyperparameters
epochs = 1

## Dataset preparation and segmentation
# X_train preparation
speed_heading_speed = np.array(pd.read_csv("Datasets_Kinematics/Vw.csv"))
length = speed_heading_speed.shape[1]
# print(speed_heading_speed, length)
slice = int(length/2)
speed = speed_heading_speed[:, :slice]
heading_speed = speed_heading_speed[:, slice:]

print(speed.shape, heading_speed.shape)

X = np.array([speed, heading_speed]).T
print(X, X.shape)

# Y_train preparation
x_pos = np.array(pd.read_csv("Datasets_Kinematics/x.csv"))
y_pos = np.array(pd.read_csv("Datasets_Kinematics/y.csv"))
th1_head = np.array(pd.read_csv("Datasets_Kinematics/th1.csv"))
th0_head = np.array(pd.read_csv("Datasets_Kinematics/th0.csv"))

print(x_pos.shape, y_pos.shape, th1_head.shape, th0_head.shape)

Y = np.array([x_pos, y_pos, th1_head, th0_head]).T
print(Y, Y.shape)

Y_selected = Y[-1:,:]

# Shuffle around
# XY = np.dstack((X, Y))
# XY = np.random.shuffle(XY)
# print(XY, XY.shape)
# X = XY[:,:, 0:X.shape[3]-1]
# Y = XY[:,:, X.shape[3]:Y.shape[3]]

print(X, X.shape)
print(Y, Y.shape)

# # # segmentation
batch_size = X.shape[0]
print(batch_size)
train_size = int(batch_size * 0.7)
valid_size = int(batch_size * 0.9)
last_one = int(batch_size - 1)

print(train_size, valid_size)
X_train, Y_train = Y[:train_size,:], X[:train_size,:]
print(X_train.shape, Y_train.shape)
X_valid, Y_valid = Y[train_size:valid_size,:], X[train_size:valid_size,:]
print(X_valid.shape, Y_valid.shape)
X_test, Y_test = Y[valid_size:,:], X[valid_size:,:]
print(X_test.shape, Y_test.shape)

dim_in = X_train.shape[2]
dim_out = Y_train.shape[2]
nb_units = 10

# # Logger
root_logdir = os.path.join(os.curdir, "Kinematics_logs")
def get_run_logdir():
    import time
    run_id = time.strftime("run_%Y_%m_%d-%H_%M_%S")
    return os.path.join(root_logdir, run_id)
run_logdir = get_run_logdir()
file_writer = tf.summary.create_file_writer(run_logdir + "/metrics")
file_writer.set_as_default()

# # Learning Rate Schedulewr
def exponential_decay(lr0, s):
    def exponential_decay_fn(epoch):
        return lr0 * 0.1 ** (epoch/s)
    return exponential_decay_fn
exponential_decay_fn = exponential_decay(lr0=0.001, s=epochs)

# # Callbacks
checkpoint_cb = keras.callbacks.ModelCheckpoint("Models/ControlRNN_Kinematics.h5", save_freq= 20)
early_stopping_cb = keras.callbacks.EarlyStopping(patience=10, restore_best_weights=True)
lr_scheduler = keras.callbacks.LearningRateScheduler(exponential_decay_fn)
tensorboard_cb = keras.callbacks.TensorBoard(run_logdir)

# # Deep Recurring Neural Network
model = keras.models.load_model("Models/ControlRNN_Kinematics.h5")
model.compile(loss="mean_squared_error", optimizer="Adam")
mse_test = model.evaluate(X_test, Y_test)
Y_pred = model.predict(Y_selected)

print(Y_pred, Y_pred.shape)
print(mse_test)

np.savetxt('Datasets_Kinematics/New/PredictedSpeedsBest.csv', np.squeeze(Y_pred, axis=0), delimiter=",")