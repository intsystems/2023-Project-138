from collections import OrderedDict
from QDrop.models.resnet import resnet18 as _resnet18
from QDrop.models.resnet import resnet50 as _resnet50
from QDrop.models.mobilenetv2 import mobilenetv2 as _mobilenetv2
from QDrop.models.mnasnet import mnasnet as _mnasnet
from QDrop.models.regnet import regnetx_600m as _regnetx_600m
from QDrop.models.regnet import regnetx_3200m as _regnetx_3200m
import torch
dependencies = ['torch']
model_path = {
    'resnet18': r'C:\Users\sedov\dev\checkpoints\resnet18-5c106cde.pth',
    'mbv2': r'C:\Users\sedov\dev\checkpoints\mobilenet_v2-b0353104.pth',
    'resnet50': r'C:\Users\sedov\dev\checkpoints\resnet50-0676ba61.pth'
}


def resnet18(pretrained=False, **kwargs):
    # Call the model, load pretrained weights
    model = _resnet18(**kwargs)
    if pretrained:
        checkpoint = torch.load(model_path['resnet18'], map_location='cpu')
        model.load_state_dict(checkpoint)
    return model


def resnet50(pretrained=False, **kwargs):
    # Call the model, load pretrained weights
    model = _resnet50(**kwargs)
    if pretrained:
        checkpoint = torch.load(model_path['resnet50'], map_location='cpu')
        model.load_state_dict(checkpoint)
    return model


def mobilenetv2(pretrained=False, **kwargs):
    # Call the model, load pretrained weights
    model = _mobilenetv2(**kwargs)
    if pretrained:
        checkpoint = torch.load(model_path['mbv2'], map_location='cpu')
        model.load_state_dict(checkpoint)
    return model

