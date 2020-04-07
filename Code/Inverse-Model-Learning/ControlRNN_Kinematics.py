import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from tensorflow import keras
import os

## REVERSED I/O

# Hyperparameters
epochs = 0

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
# tensorboard_cb = keras.callbacks.TensorBoard(run_logdir)

# # Deep Recurring Neural Network
model = keras.models.Sequential([keras.layers.Bidirectional(keras.layers.LSTM(batch_input_shape=(batch_size, None, dim_in), return_sequences=True, units=nb_units)),
                                 keras.layers.Bidirectional(keras.layers.LSTM(10, return_sequences=True)),
                                 keras.layers.Bidirectional(keras.layers.LSTM(7, return_sequences=True)),
                                 keras.layers.TimeDistributed(keras.layers.Dense(dim_out))
                                 ])
model.compile(loss="mean_squared_error", optimizer="Adam")
history = model.fit(X_train, Y_train, epochs=epochs, validation_data=(X_valid, Y_valid), callbacks=[checkpoint_cb, lr_scheduler, early_stopping_cb])
mse_test = model.evaluate(X_test, Y_test)
Y_pred = model.predict(Y_selected)

print(Y_pred, Y_pred.shape)
print(mse_test)

model.save("Models/ControlRNN_Kinematics.h5")
np.savetxt('Datasets_Kinematics/PredictedSpeeds.csv', np.squeeze(Y_pred, axis=0), delimiter=",")

def plotpath(Y):
    plt.plot(x_pos[:, -1], y_pos[:, -1], 'r')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()

# plotpath(Y_pred)

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