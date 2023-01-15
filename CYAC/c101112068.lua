--トン＝トン
function c101112068.initial_effect(c)
	--Reset monster's ATK/DEF/Level and pay LP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112068,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c101112068.target)
	e1:SetOperation(c101112068.activate)
	c:RegisterEffect(e1)
	--Set itself if the LPs are equal
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112068,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101112068)
	e2:SetCondition(c101112068.setcon)
	e2:SetTarget(c101112068.settg)
	e2:SetOperation(c101112068.setop)
	c:RegisterEffect(e2)
end
function c101112068.cfilter(c)
	return c:IsFaceup() and (c:GetAttack()>c:GetBaseAttack() or c:GetDefense()>c:GetBaseDefense() or c:GetLevel()>c:GetOriginalLevel())
end
function c101112068.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101112068.cfilter(chkc) end
	if chk==0 then return Duel.GetLP(tp)>=100 and Duel.IsExistingTarget(c101112068.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101112068.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101112068.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local paylp=false
	local c=e:GetHandler()
	local current,origin=tc:GetAttack(),tc:GetBaseAttack()
	if current~=origin then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(origin)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		paylp=true
	end
	current,origin=tc:GetDefense(),tc:GetBaseDefense()
	if current~=origin then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(origin)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		paylp=true
	end
	current,origin=tc:GetLevel(),tc:GetOriginalLevel()
	if current~=origin then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(origin)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		paylp=true
	end
	if paylp and Duel.GetLP(tp)>=100 then
		local maxval=math.floor(math.min(Duel.GetLP(tp),1000)/100)
		local t={}
		for i=1,maxval do
			t[i]=i*100
		end
		local value=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.PayLPCost(tp,value)
	end
end
function c101112068.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)==Duel.GetLP(1-tp)
end
function c101112068.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c101112068.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end
