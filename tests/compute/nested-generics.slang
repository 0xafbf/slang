//TEST(compute):COMPARE_COMPUTE:
//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):dxbinding(0),glbinding(0),out

// test specialization of nested generic functions

RWStructuredBuffer<int> outputBuffer;

interface IGetF
{
    float getF();
}

struct GetFImpl : IGetF
{
    float getF() { return 1.0; }
};

struct GetFImpl2 : IGetF
{
    float getF() { return -1.0; }
};

struct GenStruct<T : IGetF>
{
	T x;
	float genGet<U : IGetF>(U y)
    {
        return x.getF() + y.getF();
    }
};

[numthreads(1, 1, 1)]
void computeMain(uint3 dispatchThreadID : SV_DispatchThreadID)
{
	uint tid = dispatchThreadID.x;
    GenStruct<GetFImpl> obj1;
    GetFImpl2 obj2;
	float outVal = obj1.genGet(obj2);
	outputBuffer[tid] = int(outVal);
}