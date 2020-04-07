import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from tensorflow import keras

## REVERSED I/O

# Hyperparameters
epochs = 500

## Dataset preparation and segmentation
# X_train preparation
speed_heading_speed = np.array(pd.read_csv("Vw.csv"))
length = speed_heading_speed.shape[1]
# print(speed_heading_speed, length)
slice = int(length/2)
speed = speed_heading_speed[:, :slice]
heading_speed = speed_heading_speed[:, slice:]

print(speed.shape, heading_speed.shape)

X = np.array([speed, heading_speed]).T
print(X, X.shape)

# Y_train preparation
x_pos = np.array(pd.read_csv("x.csv"))
y_pos = np.array(pd.read_csv("y.csv"))
th1_head = np.array(pd.read_csv("th1.csv"))
th0_head = np.array(pd.read_csv("th0.csv"))

print(x_pos.shape, y_pos.shape, th1_head.shape, th0_head.shape)

Y = np.array([x_pos, y_pos, th1_head, th0_head]).T
print(Y, Y.shape)

# # # segmentation
batch_size = X.shape[0]
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

# # Saving the model
checkpoint_cb = keras.callbacks.ModelCheckpoint("")

# # Deep Recurring Neural Network
model = keras.models.Sequential([keras.layers.LSTM(batch_input_shape=(batch_size, None, dim_in), return_sequences=True, units=nb_units),
                                 keras.layers.LSTM(4, return_sequences=True),
                                 keras.layers.LSTM(4, return_sequences=True),
                                 keras.layers.TimeDistributed(keras.layers.Dense(dim_out))
                                 ])
model.compile(loss="mean_squared_error", optimizer="Adam")
history = model.fit(X_train, Y_train, epochs=epochs, validation_data=(X_valid, Y_valid))
mse_test = model.evaluate(X_test, Y_test)
Y_pred = model.predict(Y[-1:,:])

print(Y_pred, Y_pred.shape)
print(mse_test)

model.save("ControlRNN.h5")
np.savetxt('PredictedSpeeds.csv', np.squeeze(Y_pred, axis=0), delimiter=",")

def plotpath(Y):
    plt.plot(x_pos[:, -1], y_pos[:, -1], 'r')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()

plotpath(Y_pred)

def plotting(history):
    plt.plot(history.history['loss'], color = "red")
    plt.plot(history.history['val_loss'], color = "blue")
    red_patch = mpatches.Patch(color='red', label='Training')
    blue_patch = mpatches.Patch(color='blue', label='Test')
    plt.legend(handles=[red_patch, blue_patch])
    plt.xlabel('Epochs')
    plt.ylabel('MSE loss')
    plt.show()

# plt.figure(figsize=(10,8))
plotting(history)

