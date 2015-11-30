//
//  Shaders.metal
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/24.
//  Copyright © 2015年 MLTT. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex
{
    float4 position [[position]];
    float4 color;
};

vertex Vertex vertexMain(device Vertex *vertices [[buffer(0)]],
                          uint vid [[vertex_id]])
{
    return vertices[vid];
}

fragment float4 fragmentMain(Vertex inVertex [[stage_in]])
{
    return inVertex.color;
}

