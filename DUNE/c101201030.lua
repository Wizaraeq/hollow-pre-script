--クリック＆エコー
function c101201030.initial_effect(c)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c101201030.fuslimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	--Special Summon it to the field of the opponent of the player that used this card as material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(101201030,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCountLimit(2,101201030)
	e6:SetCondition(c101201030.spcond)
	e6:SetTarget(c101201030.sptg)
	e6:SetOperation(c101201030.spop)
	c:RegisterEffect(e6)
	--You must play with your hand revealed if this card was summoned by its own effect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_PUBLIC)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c101201030.pubcon)
	e7:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e7)
end
function c101201030.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c101201030.spcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c101201030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c101201030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummonStep(c,0,tp,1-rp,false,false,POS_FACEUP) then
		c:RegisterFlagEffect(101201030,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	Duel.SpecialSummonComplete()
end
function c101201030.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101201030)>0
end