# Test function.
import h5py

def hello(event, context):
  print(h5py.version.info)
#  return event['data']
  return h5py.version.info
