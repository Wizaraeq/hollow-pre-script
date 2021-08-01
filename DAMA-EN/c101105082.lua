--Pazuzule
function c101105082.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- Change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105082,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c101105082.sctg)
	e1:SetOperation(c101105082.scop)
	c:RegisterEffect(e1)
	-- Pendulum Summons cannot be negated
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c101105082.distg)
	c:RegisterEffect(e2)
end
function c101105082.scfilter(c,sc)
	return c:GetOriginalLevel()>0 and sc~=c:GetOriginalLevel()
end
function c101105082.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c101105082.scfilter,tp,LOCATION_PZONE,0,1,c,c:GetLeftScale()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101105082.scfilter,tp,LOCATION_PZONE,0,1,1,c,c:GetLeftScale())
end
function c101105082.scop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local lv=tc:GetOriginalLevel()
		if lv~=c:GetLeftScale() then
			-- Change scale
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			e2:SetValue(lv)
			c:RegisterEffect(e2)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101105082.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101105082.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c101105082.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end