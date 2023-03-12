--双頭竜キング・レックス
function c101201007.initial_effect(c)
	--Special Summon itself from the hand if you control no monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101201007,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101201007.spcon)
	c:RegisterEffect(e1)
	--Destroy 1 monster on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201007,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101201007+100)
	e2:SetTarget(c101201007.destg)
	e2:SetOperation(c101201007.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101201007.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c101201007.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
end
function c101201007.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function c101201007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup( c101201007.filter,tp,LOCATION_MZONE,0,nil)
	local _,maxatk=g:GetMaxGroup(Card.GetAttack)
	maxatk=maxatk or 0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101201007.desfilter(chkc,maxatk) end
	if chk==0 then return Duel.IsExistingTarget(c101201007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,maxatk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,c101201007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,maxatk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c101201007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end