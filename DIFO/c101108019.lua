--捕食植物トリアンティス
function c101108019.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetValue(c101108019.mtval)
	c:RegisterEffect(e1)
	-- Place Predator Counters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108018,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101108019.ctcon)
	e2:SetTarget(c101108019.cttg)
	e2:SetOperation(c101108019.ctop)
	c:RegisterEffect(e2)
end
function c101108019.mtval(e,c)
	if not c then return false end
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c101108019.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_FUSION and c:IsFaceup()
		and c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) 
end
function c101108019.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1041,1) end
end
function c101108019.ctop(e,tp,eg,ep,ev,re,r,rp)
	local max=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,max,nil,0x1041,1)
	if #g<1 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		tc:AddCounter(0x1041,1)
		if tc:GetLevel()>1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c101108019.lvcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
	end
end
function c101108019.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end 